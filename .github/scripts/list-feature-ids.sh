#!/usr/bin/env bash
# Lists feature ids from src/<feature>/devcontainer-feature.json.
set -euo pipefail

repo_root="${1:-.}"
find "${repo_root}/src" -mindepth 1 -maxdepth 1 -type d -print \
  | sed "s|.*/||" \
  | sort
