#!/bin/bash
# Tests credential seeding for the claude feature.
set -e

source dev-container-features-test-lib

FEATURE_DIR="/usr/local/share/devcontainer-feature-ai-assistant/claude"
USER_HOME="${HOME:-/home/node}"
TARGET="${USER_HOME}/.claude/.credentials.json"
SEED_DIR="${USER_HOME}/.cred-seed/claude"

check "seed-credentials script present" test -x "${FEATURE_DIR}/seed-credentials.sh"

rm -f "${TARGET}"
"${FEATURE_DIR}/seed-credentials.sh"
check "no error when seed absent" true
check "target absent when seed absent" test ! -f "${TARGET}"

mkdir -p "${SEED_DIR}"
echo '{"token":"test"}' > "${SEED_DIR}/.credentials.json"
"${FEATURE_DIR}/seed-credentials.sh"
check "credentials copied when seed present" test -f "${TARGET}"
check "seeded file mode is 600" test "$(stat -c '%a' "${TARGET}")" = "600"
check "seeded file content correct" grep -q token "${TARGET}"

echo '{"token":"drift"}' > "${TARGET}"
"${FEATURE_DIR}/seed-credentials.sh"
check "existing credentials left untouched" grep -q drift "${TARGET}"

rm -f "${TARGET}" "${SEED_DIR}/.credentials.json"
rmdir "${SEED_DIR}" 2>/dev/null || true

reportResults
