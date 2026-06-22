#!/bin/bash
# Scenario: claude + t3 installed together with claude as the default provider.
set -e

source dev-container-features-test-lib

check "claude binary exists" bash -c "command -v claude"
check "t3 binary exists" bash -c "command -v t3"
check "t3 settings point to claudeAgent" bash -c "node -e 'const s=JSON.parse(require(\"fs\").readFileSync(\"/usr/local/share/t3-devcontainer/settings.json\")); process.exit(s.textGenerationModelSelection.instanceId===\"claudeAgent\"?0:1)'"
check "claude provider enabled" bash -c "node -e 'const s=JSON.parse(require(\"fs\").readFileSync(\"/usr/local/share/t3-devcontainer/settings.json\")); process.exit(s.providers.claudeAgent.enabled===true?0:1)'"

reportResults
