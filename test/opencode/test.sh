#!/bin/bash
# Tests run inside a container built with the 'opencode' feature and no options.
#
# Run manually:
#   devcontainer features test \
#     --features opencode \
#     --skip-scenarios \
#     --base-image node:24 \
#     /path/to/repo
set -e

source dev-container-features-test-lib

check "opencode binary exists" bash -c "command -v opencode"
check "opencode on feature PATH for /bin/sh" bash -c '/bin/sh -c "command -v opencode"'
check "opencode resolves via opencode-bin path" bash -c 'test "$(readlink -f "$(command -v opencode)")" = "$(readlink -f "${HOME}/.opencode/bin/opencode")"'
check "opencode --version exits cleanly" bash -c "opencode --version"

reportResults
