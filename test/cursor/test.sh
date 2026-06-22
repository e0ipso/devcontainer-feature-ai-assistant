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

reportResults
