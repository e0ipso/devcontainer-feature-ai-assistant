#!/bin/bash
# Scenario: codex + t3 installed together with codex as the default provider.
set -e

source dev-container-features-test-lib

check "codex binary exists" bash -c "command -v codex"
check "t3 binary exists" bash -c "command -v t3"
check "t3 settings point to codex" bash -c "node -e 'const s=JSON.parse(require(\"fs\").readFileSync(\"/usr/local/share/t3-devcontainer/settings.json\")); process.exit(s.textGenerationModelSelection.instanceId===\"codex\"?0:1)'"
check "codex provider enabled" bash -c "node -e 'const s=JSON.parse(require(\"fs\").readFileSync(\"/usr/local/share/t3-devcontainer/settings.json\")); process.exit(s.providers.codex.enabled===true?0:1)'"

reportResults
