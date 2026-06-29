#!/bin/bash
# Tests credential seeding for the codex feature.
set -e

source dev-container-features-test-lib

FEATURE_DIR="/usr/local/share/devcontainer-feature-ai-assistant/codex"
USER_HOME="${HOME:-/home/node}"
TARGET="${USER_HOME}/.openai/auth.json"
SEED_DIR="${USER_HOME}/.cred-seed/codex"

check "seed-credentials script present" test -x "${FEATURE_DIR}/seed-credentials.sh"

rm -f "${TARGET}"
"${FEATURE_DIR}/seed-credentials.sh"
check "no error when seed absent" true
check "target absent when seed absent" test ! -f "${TARGET}"

mkdir -p "${SEED_DIR}"
echo '{"token":"test"}' > "${SEED_DIR}/auth.json"
"${FEATURE_DIR}/seed-credentials.sh"
check "credentials copied when seed present" test -f "${TARGET}"
check "seeded file mode is 600" test "$(stat -c '%a' "${TARGET}")" = "600"
check "seeded file content correct" grep -q token "${TARGET}"

echo '{"token":"drift"}' > "${TARGET}"
"${FEATURE_DIR}/seed-credentials.sh"
check "existing credentials left untouched" grep -q drift "${TARGET}"

rm -f "${TARGET}" "${SEED_DIR}/auth.json"
rmdir "${SEED_DIR}" 2>/dev/null || true

reportResults
