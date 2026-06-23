#!/usr/bin/env bash
# Installs the OpenCode CLI into the dev container.
#
# Runs as root during the image build. The installer runs as the remote
# (non-root) user so artifacts land in the user's home and on a shared,
# user-writable npm prefix instead of root's home, which would be invisible at
# runtime.
set -euo pipefail

USERNAME="${_REMOTE_USER:-node}"
USER_HOME="${_REMOTE_USER_HOME:-/home/${USERNAME}}"
NPM_PREFIX="/usr/local/share/npm-global"
OPENCODE_LINK="/usr/local/share/opencode-bin"

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

link_user_bins_to_npm_prefix() {
  local bin_dir
  for bin_dir in "${USER_HOME}/.local/bin" "${USER_HOME}/.opencode/bin"; do
    if [ -d "${bin_dir}" ]; then
      for bin in "${bin_dir}"/*; do
        if [ -e "$bin" ]; then
          ln -sf "$bin" "${NPM_PREFIX}/bin/$(basename "$bin")"
        fi
      done
    fi
  done
}

link_opencode_bin_dir() {
  local opencode_bin="${USER_HOME}/.opencode/bin/opencode"
  if [ ! -x "${opencode_bin}" ]; then
    echo "ERROR: OpenCode binary not found at ${opencode_bin}" >&2
    exit 1
  fi

  ln -sfn "${USER_HOME}/.opencode/bin" "${OPENCODE_LINK}"
}

verify_opencode_on_path() {
  local feature_path="${NPM_PREFIX}/bin:${OPENCODE_LINK}:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"

  if ! PATH="${feature_path}" /bin/sh -c 'command -v opencode' >/dev/null 2>&1; then
    echo "ERROR: opencode is not reachable from /bin/sh (postStartCommand PATH)" >&2
    exit 1
  fi
}

echo "==> Installing OpenCode"
run_as_user 'curl -fsSL https://opencode.ai/install | bash'
link_user_bins_to_npm_prefix
link_opencode_bin_dir
verify_opencode_on_path
echo "==> OpenCode installed."
