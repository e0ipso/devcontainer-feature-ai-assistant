#!/bin/bash
# Tests run inside a container built with the 'codex' feature and
# updateOnPostStart explicitly disabled.
set -e

source dev-container-features-test-lib

check "codex binary exists" bash -c "command -v codex"
check "post-start update script absent when disabled" test ! -e /usr/local/share/devcontainer-feature-ai-assistant/codex/update.sh

reportResults
