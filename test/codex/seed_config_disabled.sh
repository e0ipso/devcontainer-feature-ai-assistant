#!/bin/bash
# Tests run inside a container built with seedConfig explicitly disabled.
set -e

source dev-container-features-test-lib

check "seed-config script absent when disabled" test ! -e /usr/local/share/devcontainer-feature-ai-assistant/codex/seed-config.sh
check "baked default absent when disabled" test ! -e /usr/local/share/devcontainer-feature-ai-assistant/codex/config.toml

reportResults
