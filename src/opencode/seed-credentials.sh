#!/usr/bin/env bash
# Seeds OpenCode provider credentials once from a host mount.
set -euo pipefail

USER_HOME="${_REMOTE_USER_HOME:-${HOME}}"
TARGET_PATH="${USER_HOME}/.config/opencode/auth.json"
SEED_PATH="${USER_HOME}/.cred-seed/opencode/auth.json"

mkdir -p "$(dirname "${TARGET_PATH}")"

if [ ! -f "${TARGET_PATH}" ] && [ -f "${SEED_PATH}" ]; then
  cp "${SEED_PATH}" "${TARGET_PATH}"
  chmod 600 "${TARGET_PATH}"
fi
