#!/usr/bin/env bash
# Set GHCR package visibility to public for the feature collection and each feature.
set -euo pipefail

repo_root="${1:-.}"
namespace="${2:-devcontainer-feature-ai-assistant}"
owner="${GITHUB_REPOSITORY_OWNER:?GITHUB_REPOSITORY_OWNER is required}"

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
packages=("${namespace}")

for feature in "$("${script_dir}/list-feature-ids.sh" "${repo_root}")"; do
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
