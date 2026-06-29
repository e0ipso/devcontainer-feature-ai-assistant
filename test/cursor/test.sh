#!/bin/bash
# Tests run inside a container built with the 'cursor' feature and no options.
#
# Run manually:
#   devcontainer features test \
#     --features cursor \
#     --skip-scenarios \
#     --base-image node:24 \
#     /path/to/repo
set -e

source dev-container-features-test-lib

check "agent binary exists" bash -c "command -v agent"
check "post-start update script present by default" test -x /usr/local/share/devcontainer-feature-ai-assistant/cursor/update.sh
check "seed-config script present by default" test -x /usr/local/share/devcontainer-feature-ai-assistant/cursor/seed-config.sh
check "baked default cli-config present" test -f /usr/local/share/devcontainer-feature-ai-assistant/cursor/cli-config.json

reportResults
