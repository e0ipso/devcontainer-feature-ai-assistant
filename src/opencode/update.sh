#!/usr/bin/env bash
# Re-runs the OpenCode install to update to the latest version.
#
# Invoked during postStart by the 'opencode' devcontainer feature when
# updateOnPostStart is enabled. Runs as the remote user; PATH already includes
# the shared npm-global prefix via containerEnv, and NPM_CONFIG_PREFIX is
# exported below so npm installs into that same prefix.
set -euo pipefail

export NPM_CONFIG_PREFIX="/usr/local/share/npm-global"

echo "==> Updating OpenCode (postStart)"
npm install -g opencode-ai
echo "==> OpenCode updated."
