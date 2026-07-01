# t3 CLI (`t3`)

Installs the [T3 Code](https://github.com/pingdotgg/t3code) CLI globally via npm and seeds server settings derived from T3's `ServerSettings` schema.

## Usage

Add to `.devcontainer/devcontainer.json`:

```jsonc
{
  "image": "node:24",
  "features": {
    "ghcr.io/<owner>/devcontainer-feature-ai-assistant/t3:1": {}
  }
}
```

Replace `<owner>` with the GitHub user or org that publishes this collection.

## Quick start

Use defaults (Codex, Claude agent, Grok, and OpenCode enabled; Cursor disabled):

```jsonc
"ghcr.io/<owner>/devcontainer-feature-ai-assistant/t3:1": {}
```

Use Claude as the default model provider:

```jsonc
"ghcr.io/<owner>/devcontainer-feature-ai-assistant/t3:1": {
  "textGenerationModelSelectionInstanceId": "claudeAgent",
  "textGenerationModelSelectionModel": "claude-sonnet-4-6",
  "providersClaudeAgentEnabled": true,
  "providersCodexEnabled": false
}
```

Disable Grok and change the git-fetch interval:

```jsonc
"ghcr.io/<owner>/devcontainer-feature-ai-assistant/t3:1": {
  "automaticGitFetchInterval": "60000",
  "providersGrokEnabled": false
}
```

Point OpenCode at an existing server:

```jsonc
"ghcr.io/<owner>/devcontainer-feature-ai-assistant/t3:1": {
  "providersOpenCodeServerUrl": "http://host.docker.internal:4096",
  "providersOpenCodeServerPassword": "secret"
}
```

## Requirements

- Node.js in the base image, or `ghcr.io/devcontainers/features/node` (declared via `installsAfter`).

## What the feature does at build time

- Runs `npm install -g t3@<version>` as the remote user into `/usr/local/share/npm-global/bin`
- Writes flattened settings to `/usr/local/share/devcontainer-feature-ai-assistant/t3/settings.json` (and mirrors to `/usr/local/share/t3-devcontainer/settings.json` for compatibility)
- Sets `PATH` via feature `containerEnv`
- t3 applies its own defaults for any omitted or empty fields at runtime

## Options overview

The authoritative option list and defaults live in [`devcontainer-feature.json`](devcontainer-feature.json). Options map to fields in T3's [`ServerSettings`](https://github.com/pingdotgg/t3code/blob/main/packages/contracts/src/settings.ts) schema; nested settings are flattened into individual typed options because dev container Features cannot accept arbitrary JSON objects.

| Group | Options |
| ----- | ------- |
| **General** | `version`, `updateOnPostStart`, `enableAssistantStreaming`, `enableProviderUpdateChecks`, `automaticGitFetchInterval`, `defaultThreadEnvMode` (`"local"` or `"worktree"`), `newWorktreesStartFromOrigin`, `addProjectBaseDirectory`, `seedConfig` |
| **Model** | `textGenerationModelSelectionInstanceId`, `textGenerationModelSelectionModel` |
| **Observability** | `observabilityOtlpTracesUrl`, `observabilityOtlpMetricsUrl` |
| **Providers** | `providersCodex*`, `providersClaudeAgent*`, `providersCursor*`, `providersGrok*`, `providersOpenCode*` |

Non-obvious details:

- `updateOnPostStart` — when enabled (default), runs `npm install -g t3` on every `postStart` to pull the latest version, ignoring the pinned `version`. Set to `false` to keep the version installed at build time and avoid network traffic on container start.
- `providersOpenCodeServerUrl` — leave blank to let t3 spawn the OpenCode server
- `providersOpenCodeServerPassword` — stored in plain text on disk
- `defaultThreadEnvMode` — must be `"local"` or `"worktree"`

## Runtime settings

On `postStart`, when `seedConfig` is enabled (default), the feature seeds `$T3CODE_HOME/userdata/settings.json` **only if that file does not already exist**, so t3 can drift afterward.

Source precedence:

1. Host seed: `~/.cred-seed/t3/settings.json` (bind-mount from your machine)
2. Image-baked default: `/usr/local/share/devcontainer-feature-ai-assistant/t3/settings.json`

The seeded file is created with mode `600`. Set `"seedConfig": false` to disable seeding.

Do not bind-mount your live desktop `~/.t3/userdata/settings.json` read-only — t3 writes settings atomically, so a single-file bind mount can become stale when the host process renames over the file.

## Local development

From this repo root:

```bash
devcontainer features test -f t3 .
devcontainer features test -f t3 -i node:24 .
```

See the [repository README](../../README.md) for publishing, combining features, and the full test matrix.
