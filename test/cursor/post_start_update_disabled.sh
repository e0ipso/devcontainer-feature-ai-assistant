#!/bin/bash
# Tests run inside a container built with the 'cursor' feature and
# updateOnPostStart explicitly disabled.
set -e

source dev-container-features-test-lib

check "agent binary exists" bash -c "command -v agent"
check "post-start update script absent when disabled" test ! -e /usr/local/share/devcontainer-feature-ai-assistant/cursor/update.sh

reportResults
