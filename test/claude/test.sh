#!/bin/bash
# Tests run inside a container built with the 'claude' feature and no options.
# Runs as root unless --remote-user is specified.
#
# Run manually:
#   devcontainer features test \
#     --features claude \
#     --skip-scenarios \
#     --base-image node:24 \
#     /path/to/repo
set -e

source dev-container-features-test-lib

check "claude binary exists" bash -c "command -v claude"
check "claude --version exits cleanly" bash -c "claude --version"
check "post-start update script present by default" test -x /usr/local/share/devcontainer-feature-ai-assistant/claude/update.sh

reportResults
