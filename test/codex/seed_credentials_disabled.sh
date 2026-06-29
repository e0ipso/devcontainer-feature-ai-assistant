#!/bin/bash
# Tests run inside a container built with seedCredentials explicitly disabled.
set -e

source dev-container-features-test-lib

check "seed-credentials script absent when disabled" test ! -e /usr/local/share/devcontainer-feature-ai-assistant/codex/seed-credentials.sh

reportResults
