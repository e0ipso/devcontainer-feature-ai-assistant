#!/bin/bash
# Tests run inside a container built with the 't3' feature and
# updateOnPostStart explicitly disabled.
set -e

source dev-container-features-test-lib

check "t3 binary exists" bash -c "command -v t3"
check "post-start update script absent when disabled" test ! -e /usr/local/share/devcontainer-feature-ai-assistant/t3/update.sh

reportResults
