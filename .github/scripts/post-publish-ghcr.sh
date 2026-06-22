#!/usr/bin/env bash
# Set GHCR package visibility to public and verify major-version tags are pullable.
set -euo pipefail

repo_root="${1:-.}"
namespace="${2:-devcontainer-feature-ai-assistant}"
owner="${GITHUB_REPOSITORY_OWNER:?GITHUB_REPOSITORY_OWNER is required}"

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
packages=("${namespace}")
failed=0

mapfile -t features < <("${script_dir}/list-feature-ids.sh" "${repo_root}")
for feature in "${features[@]}"; do
  packages+=("${namespace}/${feature}")
done

for package in "${packages[@]}"; do
  encoded="${package//\//%2F}"
  settings_url="https://github.com/users/${owner}/packages/container/${encoded}/settings"

  visibility="$(gh api "/user/packages/container/${encoded}" --jq .visibility)"
  if [ "${visibility}" != "public" ]; then
    echo "Setting visibility=public for ${package}"
    gh api --method PATCH \
      -H "Accept: application/vnd.github+json" \
      "/user/packages/container/${encoded}" \
      --input - <<< '{"visibility":"public"}'
    visibility="$(gh api "/user/packages/container/${encoded}" --jq .visibility)"
  fi

  if [ "${visibility}" != "public" ]; then
    echo "::error title=Package is not public::${package} visibility is '${visibility}', expected 'public'. Set it manually: ${settings_url}"
    exit 1
  fi

  echo "✓ ${package} is public"
done

for feature in "${features[@]}"; do
  version="$(jq -r .version "${repo_root}/src/${feature}/devcontainer-feature.json")"
  major="${version%%.*}"
  image="${namespace}/${feature}"

  token="$(curl -fsSL "https://ghcr.io/token?scope=repository:${owner}/${image}:pull" | jq -r .token)"
  if [ -z "${token}" ] || [ "${token}" = "null" ]; then
    echo "::error::Could not get an anonymous pull token for ghcr.io/${owner}/${image}"
    failed=1
    continue
  fi

  status="$(curl -sS -o /dev/null -w "%{http_code}" \
    "https://ghcr.io/v2/${owner}/${image}/manifests/${major}" \
    -H "Authorization: Bearer ${token}" \
    -H "Accept: application/vnd.oci.image.manifest.v1+json")"
  if [ "${status}" = "200" ]; then
    echo "✓ ghcr.io/${owner}/${image}:${major} is pullable"
  else
    echo "::error::ghcr.io/${owner}/${image}:${major} returned HTTP ${status} (expected 200)"
    failed=1
  fi
done

if [ "${failed}" -ne 0 ]; then
  exit 1
fi
