#!/bin/bash
# Tests run inside a container built with the 'claude' feature and
# updateOnPostStart explicitly disabled.
set -e

source dev-container-features-test-lib

check "claude binary exists" bash -c "command -v claude"
check "post-start update script absent when disabled" test ! -e /usr/local/share/devcontainer-feature-ai-assistant/claude/update.sh

reportResults
