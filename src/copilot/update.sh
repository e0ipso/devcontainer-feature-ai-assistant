#!/usr/bin/env bash
# Re-runs the GitHub Copilot CLI install to update to the latest version.
#
# Invoked during postStart by the 'copilot' devcontainer feature when
# updateOnPostStart is enabled. Runs as the remote user; PATH already includes
# the shared npm-global prefix via containerEnv, and NPM_CONFIG_PREFIX is
# exported below so npm installs into that same prefix.
set -euo pipefail

export NPM_CONFIG_PREFIX="/usr/local/share/npm-global"

echo "==> Updating GitHub Copilot CLI (postStart)"
npm install -g @github/copilot
echo "==> GitHub Copilot CLI updated."
