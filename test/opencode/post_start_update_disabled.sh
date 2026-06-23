#!/bin/bash
# Tests run inside a container built with the 'opencode' feature and
# updateOnPostStart explicitly disabled.
set -e

source dev-container-features-test-lib

check "opencode binary exists" bash -c "command -v opencode"
check "post-start update script absent when disabled" test ! -e /usr/local/share/devcontainer-feature-ai-assistant/opencode/update.sh

reportResults
