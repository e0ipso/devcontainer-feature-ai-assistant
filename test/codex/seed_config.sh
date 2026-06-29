#!/bin/bash
# Tests configuration seeding for the codex feature.
set -e

source dev-container-features-test-lib

FEATURE_DIR="/usr/local/share/devcontainer-feature-ai-assistant/codex"
USER_HOME="${HOME:-/home/node}"
TARGET="${USER_HOME}/.codex/config.toml"
SEED_DIR="${USER_HOME}/.cred-seed/codex"

check "baked default present" test -f "${FEATURE_DIR}/config.toml"
check "seed-config script present" test -x "${FEATURE_DIR}/seed-config.sh"

rm -f "${TARGET}"
"${FEATURE_DIR}/seed-config.sh"
check "default copied when target absent" test -f "${TARGET}"
check "seeded file mode is 600" test "$(stat -c '%a' "${TARGET}")" = "600"

echo "drift-marker" > "${TARGET}"
"${FEATURE_DIR}/seed-config.sh"
check "existing target left untouched" grep -q drift-marker "${TARGET}"

rm -f "${TARGET}"
mkdir -p "${SEED_DIR}"
echo "from-host-seed" > "${SEED_DIR}/config.toml"
"${FEATURE_DIR}/seed-config.sh"
check "host seed copied when present" grep -q from-host-seed "${TARGET}"

rm -f "${TARGET}" "${SEED_DIR}/config.toml"
rmdir "${SEED_DIR}" 2>/dev/null || true
"${FEATURE_DIR}/seed-config.sh"
check "fallback to baked default without host seed" test -f "${TARGET}"

reportResults
