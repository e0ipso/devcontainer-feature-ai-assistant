#!/usr/bin/env bash
# Seeds Claude Code settings once from a host mount or the image-baked default.
set -euo pipefail

USER_HOME="${_REMOTE_USER_HOME:-${HOME}}"
TARGET_PATH="${USER_HOME}/.claude/settings.json"
SEED_PATH="${USER_HOME}/.cred-seed/claude/settings.json"
DEFAULT_PATH="/usr/local/share/devcontainer-feature-ai-assistant/claude/settings.json"

mkdir -p "$(dirname "${TARGET_PATH}")"

if [ ! -f "${TARGET_PATH}" ]; then
  if [ -f "${SEED_PATH}" ]; then
    cp "${SEED_PATH}" "${TARGET_PATH}"
  elif [ -f "${DEFAULT_PATH}" ]; then
    cp "${DEFAULT_PATH}" "${TARGET_PATH}"
  fi

  if [ -f "${TARGET_PATH}" ]; then
    chmod 600 "${TARGET_PATH}"
  fi
fi
