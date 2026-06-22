#!/usr/bin/env bash
# Installs the t3 CLI into the dev container and seeds server settings.
#
# Runs as root during the image build. The npm install runs as the remote
# (non-root) user against a shared, user-writable npm prefix so the binary is
# visible at runtime instead of landing in root's home.
set -euo pipefail

DEFAULT_SETTINGS_DIR="/usr/local/share/t3-devcontainer"
USERNAME="${_REMOTE_USER:-node}"
USER_HOME="${_REMOTE_USER_HOME:-/home/${USERNAME}}"
NPM_PREFIX="/usr/local/share/npm-global"
T3_VERSION="${VERSION:-latest}"

# Shared npm global prefix the remote user can write to without sudo.
mkdir -p "${NPM_PREFIX}/bin"
chown -R "${USERNAME}:${USERNAME}" "${NPM_PREFIX}"

echo "==> Installing t3@${T3_VERSION}"
su - "${USERNAME}" -c \
  "export NPM_CONFIG_PREFIX='${NPM_PREFIX}' PATH=\"${NPM_PREFIX}/bin:${USER_HOME}/.local/bin:\$PATH\"; npm install -g 't3@${T3_VERSION}'"

mkdir -p "${DEFAULT_SETTINGS_DIR}"

node -e "
const fs = require('fs');

const bool = (v) => String(v).toLowerCase() === 'true';
const str = (v) => v === undefined ? '' : String(v);
const int = (v, fallback) => {
  const n = parseInt(String(v), 10);
  return Number.isNaN(n) ? fallback : n;
};

const settings = {
  enableAssistantStreaming: bool(process.env.ENABLEASSISTANTSTREAMING),
  enableProviderUpdateChecks: bool(process.env.ENABLEPROVIDERUPDATECHECKS),
  automaticGitFetchInterval: int(process.env.AUTOMATICGITFETCHINTERVAL, 30000),
  defaultThreadEnvMode: str(process.env.DEFAULTTHREADENVMODE) || 'local',
  newWorktreesStartFromOrigin: bool(process.env.NEWWORKTREESSTARTFROMORIGIN),
  addProjectBaseDirectory: str(process.env.ADDPROJECTBASEDIRECTORY),
  textGenerationModelSelection: {
    instanceId: str(process.env.TEXTGENERATIONMODELSELECTIONINSTANCEID) || 'codex',
    model: str(process.env.TEXTGENERATIONMODELSELECTIONMODEL) || 'gpt-5.4-mini',
  },
  observability: {
    otlpTracesUrl: str(process.env.OBSERVABILITYOTLPTRACESURL),
    otlpMetricsUrl: str(process.env.OBSERVABILITYOTLPMETRICSURL),
  },
  providers: {
    codex: {
      enabled: bool(process.env.PROVIDERSCODEXENABLED),
      binaryPath: str(process.env.PROVIDERSCODEXBINARYPATH) || 'codex',
      homePath: str(process.env.PROVIDERSCODEXHOMEPATH),
      shadowHomePath: str(process.env.PROVIDERSCODEXSHADOWHOMEPATH),
    },
    claudeAgent: {
      enabled: bool(process.env.PROVIDERSCLAUDEAGENTENABLED),
      binaryPath: str(process.env.PROVIDERSCLAUDEAGENTBINARYPATH) || 'claude',
      homePath: str(process.env.PROVIDERSCLAUDEAGENTHOMEPATH),
      launchArgs: str(process.env.PROVIDERSCLAUDEAGENTLAUNCHARGS),
    },
    cursor: {
      enabled: bool(process.env.PROVIDERSCURSORENABLED),
      binaryPath: str(process.env.PROVIDERSCURSORBINARYPATH) || 'agent',
      apiEndpoint: str(process.env.PROVIDERSCURSORAPIENDPOINT),
    },
    grok: {
      enabled: bool(process.env.PROVIDERSGROKENABLED),
      binaryPath: str(process.env.PROVIDERSGROKBINARYPATH) || 'grok',
    },
    opencode: {
      enabled: bool(process.env.PROVIDERSOPENCODEENABLED),
      binaryPath: str(process.env.PROVIDERSOPENCODEBINARYPATH) || 'opencode',
      serverUrl: str(process.env.PROVIDERSOPENCODESERVERURL),
      serverPassword: str(process.env.PROVIDERSOPENCODESERVERPASSWORD),
    },
  },
};

fs.writeFileSync(
  '${DEFAULT_SETTINGS_DIR}/settings.json',
  JSON.stringify(settings, null, 2) + '\n',
);
"

chmod 644 "${DEFAULT_SETTINGS_DIR}/settings.json"

echo "==> t3 installed."
