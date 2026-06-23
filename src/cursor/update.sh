#!/usr/bin/env bash
# Re-runs the Cursor CLI installer to update to the latest version.
#
# Invoked during postStart by the 'cursor' devcontainer feature when
# updateOnPostStart is enabled. Runs as the remote user; the installer places
# binaries in ~/.local/bin, which are then linked into the shared npm-global
# prefix so they appear on PATH (set via containerEnv).
set -euo pipefail

USER_HOME="${HOME:-/home/$(id -un)}"
NPM_PREFIX="/usr/local/share/npm-global"

echo "==> Updating Cursor CLI (postStart)"
curl https://cursor.com/install -fsS | bash

# Link user-local bins into the shared npm prefix so they're on PATH.
if [ -d "${USER_HOME}/.local/bin" ]; then
  for bin in "${USER_HOME}/.local/bin"/*; do
    [ -e "$bin" ] && ln -sf "$bin" "${NPM_PREFIX}/bin/$(basename "$bin")"
  done
fi
echo "==> Cursor CLI updated."
