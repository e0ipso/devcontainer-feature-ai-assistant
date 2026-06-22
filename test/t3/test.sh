#!/bin/bash
# Tests run inside a container built with the 't3' feature and no options.
# All option values fall back to their defaults.
#
# Run manually:
#   devcontainer features test \
#     --features t3 \
#     --skip-scenarios \
#     --base-image node:24 \
#     /path/to/repo
set -e

source dev-container-features-test-lib

check "t3 binary exists" bash -c "command -v t3"
check "t3 settings file written" test -f /usr/local/share/t3-devcontainer/settings.json
check "settings.json is valid JSON" bash -c "node -e 'JSON.parse(require(\"fs\").readFileSync(\"/usr/local/share/t3-devcontainer/settings.json\"))'"
check "default model instanceId is codex" bash -c "node -e 'const s=JSON.parse(require(\"fs\").readFileSync(\"/usr/local/share/t3-devcontainer/settings.json\")); process.exit(s.textGenerationModelSelection.instanceId===\"codex\"?0:1)'"

reportResults
