#!/bin/bash
# Scenario: t3 installed with claudeAgent as the text generation provider.
set -e

source dev-container-features-test-lib

check "t3 binary exists" bash -c "command -v t3"
check "settings.json written" test -f /usr/local/share/t3-devcontainer/settings.json
check "instanceId is claudeAgent" bash -c "node -e 'const s=JSON.parse(require(\"fs\").readFileSync(\"/usr/local/share/t3-devcontainer/settings.json\")); process.exit(s.textGenerationModelSelection.instanceId===\"claudeAgent\"?0:1)'"
check "model is claude-sonnet-4-6" bash -c "node -e 'const s=JSON.parse(require(\"fs\").readFileSync(\"/usr/local/share/t3-devcontainer/settings.json\")); process.exit(s.textGenerationModelSelection.model===\"claude-sonnet-4-6\"?0:1)'"
check "streaming enabled" bash -c "node -e 'const s=JSON.parse(require(\"fs\").readFileSync(\"/usr/local/share/t3-devcontainer/settings.json\")); process.exit(s.enableAssistantStreaming===true?0:1)'"

reportResults
