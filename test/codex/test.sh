#!/bin/bash
# Tests run inside a container built with the 'codex' feature and no options.
#
# Run manually:
#   devcontainer features test \
#     --features codex \
#     --skip-scenarios \
#     --base-image node:24 \
#     /path/to/repo
set -e

source dev-container-features-test-lib

check "codex binary exists" bash -c "command -v codex"
check "codex --version exits cleanly" bash -c "codex --version"
check "post-start update script present by default" test -x /usr/local/share/devcontainer-feature-ai-assistant/codex/update.sh
check "seed-config script present by default" test -x /usr/local/share/devcontainer-feature-ai-assistant/codex/seed-config.sh
check "baked default config present" test -f /usr/local/share/devcontainer-feature-ai-assistant/codex/config.toml

reportResults
