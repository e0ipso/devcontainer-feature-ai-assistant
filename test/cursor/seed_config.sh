#!/bin/bash
# Tests configuration seeding for the cursor feature.
set -e

source dev-container-features-test-lib

FEATURE_DIR="/usr/local/share/devcontainer-feature-ai-assistant/cursor"
USER_HOME="${HOME:-/home/node}"
TARGET="${USER_HOME}/.cursor/cli-config.json"
SEED_DIR="${USER_HOME}/.cred-seed/cursor"

check "baked default present" test -f "${FEATURE_DIR}/cli-config.json"
check "seed-config script present" test -x "${FEATURE_DIR}/seed-config.sh"

rm -f "${TARGET}"
"${FEATURE_DIR}/seed-config.sh"
check "default copied when target absent" test -f "${TARGET}"
check "seeded file mode is 600" test "$(stat -c '%a' "${TARGET}")" = "600"

echo '{"drift":true}' > "${TARGET}"
"${FEATURE_DIR}/seed-config.sh"
check "existing target left untouched" grep -q drift "${TARGET}"

rm -f "${TARGET}"
mkdir -p "${SEED_DIR}"
echo '{"from":"host"}' > "${SEED_DIR}/cli-config.json"
"${FEATURE_DIR}/seed-config.sh"
check "host seed copied when present" grep -q from "${TARGET}"

reportResults
