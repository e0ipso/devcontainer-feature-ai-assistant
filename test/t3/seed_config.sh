#!/bin/bash
# Tests configuration seeding for the t3 feature.
set -e

source dev-container-features-test-lib

FEATURE_DIR="/usr/local/share/devcontainer-feature-ai-assistant/t3"
USER_HOME="${HOME:-/home/node}"
T3_HOME="${USER_HOME}/.t3-test-seed"
TARGET="${T3_HOME}/userdata/settings.json"
SEED_DIR="${USER_HOME}/.cred-seed/t3"

export T3CODE_HOME="${T3_HOME}"

check "baked default present" test -f "${FEATURE_DIR}/settings.json"
check "legacy baked default present" test -f /usr/local/share/t3-devcontainer/settings.json
check "seed-config script present" test -x "${FEATURE_DIR}/seed-config.sh"

rm -rf "${T3_HOME}"
"${FEATURE_DIR}/seed-config.sh"
check "default copied when target absent" test -f "${TARGET}"
check "seeded file mode is 600" test "$(stat -c '%a' "${TARGET}")" = "600"

echo '{"drift":true}' > "${TARGET}"
"${FEATURE_DIR}/seed-config.sh"
check "existing target left untouched" grep -q drift "${TARGET}"

rm -rf "${T3_HOME}"
mkdir -p "${SEED_DIR}"
echo '{"from":"host"}' > "${SEED_DIR}/settings.json"
"${FEATURE_DIR}/seed-config.sh"
check "host seed copied when present" grep -q from "${TARGET}"

reportResults
