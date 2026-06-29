#!/usr/bin/env bash
# Seeds Cursor auth credentials once from a host mount.
set -euo pipefail

USER_HOME="${_REMOTE_USER_HOME:-${HOME}}"
TARGET_PATH="${USER_HOME}/.cursor/auth.json"
SEED_PATH="${USER_HOME}/.cred-seed/cursor/auth.json"

mkdir -p "$(dirname "${TARGET_PATH}")"

if [ ! -f "${TARGET_PATH}" ] && [ -f "${SEED_PATH}" ]; then
  cp "${SEED_PATH}" "${TARGET_PATH}"
  chmod 600 "${TARGET_PATH}"
fi
