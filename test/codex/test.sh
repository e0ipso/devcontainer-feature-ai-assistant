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

reportResults
