#!/usr/bin/env bash
# Installs the Codex CLI into the dev container.
#
# Runs as root during the image build. The npm install runs as the remote
# (non-root) user against a shared, user-writable npm prefix so the binary is
# visible at runtime instead of landing in root's home.
set -euo pipefail

USERNAME="${_REMOTE_USER:-node}"
USER_HOME="${_REMOTE_USER_HOME:-/home/${USERNAME}}"
NPM_PREFIX="/usr/local/share/npm-global"
UPDATE_ON_POST_START="${UPDATEONPOSTSTART:-false}"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
UPDATE_SCRIPT_DIR="/usr/local/share/devcontainer-feature-ai-assistant/codex"

# Ensure the build prerequisites exist (the node base image already has these,
# but a Feature should not assume its base).
if ! command -v curl >/dev/null 2>&1; then
  apt-get update -y
  apt-get install -y --no-install-recommends curl ca-certificates
  rm -rf /var/lib/apt/lists/*
fi

# Shared npm global prefix the remote user can write to without sudo.
mkdir -p "${NPM_PREFIX}/bin"
chown -R "${USERNAME}:${USERNAME}" "${NPM_PREFIX}"

# Run a command as the remote user with a sane PATH/npm prefix.
run_as_user() {
  su - "${USERNAME}" -c \
    "export NPM_CONFIG_PREFIX='${NPM_PREFIX}' PATH=\"${NPM_PREFIX}/bin:${USER_HOME}/.local/bin:\$PATH\"; $1"
}

echo "==> Installing Codex"
run_as_user 'npm install -g @openai/codex'

if [ "${UPDATE_ON_POST_START}" = "true" ]; then
  install -Dm 0755 "${SCRIPT_DIR}/update.sh" "${UPDATE_SCRIPT_DIR}/update.sh"
fi

echo "==> Codex installed."
