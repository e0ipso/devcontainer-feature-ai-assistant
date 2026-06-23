#!/usr/bin/env bash
# Installs the OpenCode CLI into the dev container.
#
# Runs as root during the image build. The npm install runs as the remote
# (non-root) user against a shared, user-writable npm prefix so the binary is
# visible at runtime instead of landing in root's home.
set -euo pipefail

USERNAME="${_REMOTE_USER:-node}"
USER_HOME="${_REMOTE_USER_HOME:-/home/${USERNAME}}"
NPM_PREFIX="/usr/local/share/npm-global"

# Shared npm global prefix the remote user can write to without sudo.
mkdir -p "${NPM_PREFIX}/bin"
chown -R "${USERNAME}:${USERNAME}" "${NPM_PREFIX}"

# Run a command as the remote user with a sane PATH/npm prefix.
run_as_user() {
  su - "${USERNAME}" -c \
    "export NPM_CONFIG_PREFIX='${NPM_PREFIX}' PATH=\"${NPM_PREFIX}/bin:${USER_HOME}/.local/bin:\$PATH\"; $1"
}

echo "==> Installing OpenCode"
run_as_user 'npm install -g opencode-ai'
echo "==> OpenCode installed."
