#!/usr/bin/env bash
# Seeds t3 settings once from a host mount or the image-baked default.
set -euo pipefail

USER_HOME="${_REMOTE_USER_HOME:-${HOME}}"
T3_HOME="${T3CODE_HOME:-${USER_HOME}/.t3}"
TARGET_PATH="${T3_HOME}/userdata/settings.json"
SEED_PATH="${USER_HOME}/.cred-seed/t3/settings.json"
DEFAULT_PATH="/usr/local/share/devcontainer-feature-ai-assistant/t3/settings.json"
LEGACY_DEFAULT_PATH="/usr/local/share/t3-devcontainer/settings.json"

mkdir -p "$(dirname "${TARGET_PATH}")"

if [ ! -f "${TARGET_PATH}" ]; then
  if [ -f "${SEED_PATH}" ]; then
    cp "${SEED_PATH}" "${TARGET_PATH}"
  elif [ -f "${DEFAULT_PATH}" ]; then
    cp "${DEFAULT_PATH}" "${TARGET_PATH}"
  elif [ -f "${LEGACY_DEFAULT_PATH}" ]; then
    cp "${LEGACY_DEFAULT_PATH}" "${TARGET_PATH}"
  fi

  if [ -f "${TARGET_PATH}" ]; then
    chmod 600 "${TARGET_PATH}"
  fi
fi
