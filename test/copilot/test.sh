#!/bin/bash
# Tests run inside a container built with the 'copilot' feature and no options.
#
# Run manually:
#   devcontainer features test \
#     --features copilot \
#     --skip-scenarios \
#     --base-image node:24 \
#     /path/to/repo
set -e

source dev-container-features-test-lib

check "copilot binary exists" bash -c "command -v copilot"

reportResults
