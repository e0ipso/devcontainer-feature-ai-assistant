#!/usr/bin/env bash
# Re-runs the t3 install to update to the latest version.
#
# Invoked during postStart by the 't3' devcontainer feature when
# updateOnPostStart is enabled. Runs as the remote user; PATH already includes
# the shared npm-global prefix via containerEnv, and NPM_CONFIG_PREFIX is
# exported below so npm installs into that same prefix.
set -euo pipefail

export NPM_CONFIG_PREFIX="/usr/local/share/npm-global"

echo "==> Updating t3 (postStart)"
npm install -g t3
echo "==> t3 updated."
