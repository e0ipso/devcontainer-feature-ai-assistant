#!/usr/bin/env bash
# Seeds t3 settings once into writable T3CODE_HOME so the server can drift.
# Delegates to the published feature script when available.
set -euo pipefail

FEATURE_SCRIPT="/usr/local/share/devcontainer-feature-ai-assistant/t3/seed-config.sh"
if [ -x "${FEATURE_SCRIPT}" ]; then
  exec "${FEATURE_SCRIPT}"
fi

t3_home="${T3CODE_HOME:-/home/node/.t3}"
target_path="${t3_home}/userdata/settings.json"
seed_path="/home/node/.cred-seed/t3/settings.json"
default_path="/usr/local/share/devcontainer-feature-ai-assistant/t3/settings.json"
legacy_default_path="/usr/local/share/t3-devcontainer/settings.json"

mkdir -p "$(dirname "${target_path}")"

if [ ! -f "${target_path}" ]; then
  if [ -f "${seed_path}" ]; then
    cp "${seed_path}" "${target_path}"
  elif [ -f "${default_path}" ]; then
    cp "${default_path}" "${target_path}"
  elif [ -f "${legacy_default_path}" ]; then
    cp "${legacy_default_path}" "${target_path}"
  fi

  if [ -f "${target_path}" ]; then
    chmod 600 "${target_path}"
  fi
fi
