#!/bin/bash
# Tests run inside a container built with the 'copilot' feature and
# updateOnPostStart explicitly disabled.
set -e

source dev-container-features-test-lib

check "copilot binary exists" bash -c "command -v copilot"
check "post-start update script absent when disabled" test ! -e /usr/local/share/devcontainer-feature-ai-assistant/copilot/update.sh

reportResults
