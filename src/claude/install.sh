#!/usr/bin/env bash
# Installs the Claude Code CLI into the dev container.
#
# Runs as root during the image build. The installer runs as the remote
# (non-root) user so artifacts land in the user's home and on a shared,
# user-writable npm prefix instead of root's home, which would be invisible at
# runtime.
set -euo pipefail

USERNAME="${_REMOTE_USER:-node}"
USER_HOME="${_REMOTE_USER_HOME:-/home/${USERNAME}}"
NPM_PREFIX="/usr/local/share/npm-global"

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

link_user_local_bins_to_npm_prefix() {
  if [ -d "${USER_HOME}/.local/bin" ]; then
    for bin in "${USER_HOME}/.local/bin"/*; do
      if [ -e "$bin" ]; then
        ln -sf "$bin" "${NPM_PREFIX}/bin/$(basename "$bin")"
      fi
    done
  fi
}

echo "==> Installing Claude Code"
run_as_user 'curl -fsSL https://claude.ai/install.sh | bash'
link_user_local_bins_to_npm_prefix
echo "==> Claude Code installed."
