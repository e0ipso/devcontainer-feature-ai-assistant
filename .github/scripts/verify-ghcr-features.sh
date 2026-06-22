#!/usr/bin/env bash
# Verify published feature major-version tags are pullable from GHCR.
set -euo pipefail

repo_root="${1:-.}"
owner="${GITHUB_REPOSITORY_OWNER:?GITHUB_REPOSITORY_OWNER is required}"
namespace="${2:-devcontainer-feature-ai-assistant}"

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
failed=0

for feature in "$("${script_dir}/list-feature-ids.sh" "${repo_root}")"; do
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
