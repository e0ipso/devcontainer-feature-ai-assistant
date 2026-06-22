# t3 CLI (`t3`)

Installs the [t3](https://www.npmjs.com/package/t3) CLI globally via npm and seeds
its server settings.

## Usage

Referenced locally from `devcontainer.json` (relative to the `.devcontainer/`
folder):

```jsonc
"features": {
  "./features/t3": {}
}
```

## Options

Each option maps to a field in T3 Code's `ServerSettings` schema
(`packages/contracts/src/settings.ts`). Option defaults match T3's decoded
defaults.

| Option | Type | Default | Description |
| ------ | ---- | ------- | ----------- |
| `version` | string | `"latest"` | npm dist-tag or version to install |
| `enableAssistantStreaming` | boolean | `false` | Stream assistant responses |
| `enableProviderUpdateChecks` | boolean | `true` | Check for provider CLI updates |
| `automaticGitFetchInterval` | string | `"30000"` | Git fetch interval in milliseconds |
| `defaultThreadEnvMode` | string | `"local"` | `"local"` or `"worktree"` |
| `newWorktreesStartFromOrigin` | boolean | `false` | New worktrees start from origin |
| `addProjectBaseDirectory` | string | `""` | Extra project base directory |
| `textGenerationModelSelectionInstanceId` | string | `"codex"` | Default model provider instance id |
| `textGenerationModelSelectionModel` | string | `"gpt-5.4-mini"` | Default model name |
| `observabilityOtlpTracesUrl` | string | `""` | OTLP traces endpoint URL |
| `observabilityOtlpMetricsUrl` | string | `""` | OTLP metrics endpoint URL |
| `providersCodexEnabled` | boolean | `true` | Enable Codex provider |
| `providersCodexBinaryPath` | string | `"codex"` | Path to the Codex binary |
| `providersCodexHomePath` | string | `""` | Custom `CODEX_HOME` path |
| `providersCodexShadowHomePath` | string | `""` | Account-specific shadow Codex home |
| `providersClaudeAgentEnabled` | boolean | `true` | Enable Claude agent provider |
| `providersClaudeAgentBinaryPath` | string | `"claude"` | Path to the Claude binary |
| `providersClaudeAgentHomePath` | string | `""` | Custom HOME for the Claude agent |
| `providersClaudeAgentLaunchArgs` | string | `""` | Extra CLI args passed on session start |
| `providersCursorEnabled` | boolean | `false` | Enable Cursor agent provider |
| `providersCursorBinaryPath` | string | `"agent"` | Path to the Cursor agent binary |
| `providersCursorApiEndpoint` | string | `""` | Override the Cursor API endpoint |
| `providersGrokEnabled` | boolean | `true` | Enable Grok provider |
| `providersGrokBinaryPath` | string | `"grok"` | Path to the Grok CLI binary |
| `providersOpenCodeEnabled` | boolean | `true` | Enable OpenCode provider |
| `providersOpenCodeBinaryPath` | string | `"opencode"` | Path to the OpenCode binary |
| `providersOpenCodeServerUrl` | string | `""` | OpenCode server URL |
| `providersOpenCodeServerPassword` | string | `""` | OpenCode server password |

## Examples

Use defaults (Codex, Claude agent, Grok, and OpenCode enabled; Cursor disabled):

```jsonc
"features": {
  "./features/t3": {}
}
```

Disable Grok and change the git-fetch interval:

```jsonc
"features": {
  "./features/t3": {
    "automaticGitFetchInterval": "60000",
    "providersGrokEnabled": false
  }
}
```

Point OpenCode at an existing server:

```jsonc
"features": {
  "./features/t3": {
    "providersOpenCodeServerUrl": "http://host.docker.internal:4096",
    "providersOpenCodeServerPassword": "secret"
  }
}
```

## Notes

- Installed to the shared npm prefix `/usr/local/share/npm-global`; add its
  `bin` to `PATH` (the project's `devcontainer.json` does this via `remoteEnv`).
- The install runs as the remote (non-root) user so the binary is visible at
  runtime rather than landing in root's home.
- Options are assembled into `/usr/local/share/t3-devcontainer/settings.json`
  as the seed when no host copy is mounted. t3 applies its own defaults for any
  omitted or empty fields at runtime.
- The authoritative source of truth remains `ServerSettings` in
  [`pingdotgg/t3code`](https://github.com/pingdotgg/t3code)
  (`packages/contracts/src/settings.ts`).
- Dev Container Feature options cannot be arbitrary JSON objects, so nested
  settings are flattened into individual typed options.

## Project mounts

The project's `devcontainer.json` keeps t3 runtime state writable while seeding
settings from a read-only host copy.

| Host path or volume | Container path | Mode |
| ------------------- | -------------- | ---- |
| `t3code-home-${devcontainerId}` | `/home/node/.t3` | writable volume |
| `~/.t3/devcontainer/settings.json` | `/home/node/.cred-seed/t3/settings.json` | read-only seed bind |

`T3CODE_HOME` is set to `/home/node/.t3`. On container start,
`.devcontainer/scripts/seed-t3-settings.sh` copies settings to
`$T3CODE_HOME/userdata/settings.json` only when that runtime file does not
already exist. It prefers the read-only host seed when mounted; otherwise it
falls back to the feature-generated default. This prevents t3 from editing the
host file while still letting the container's server settings drift after the
first seed.

Do not point the read-only seed at the live desktop
`~/.t3/userdata/settings.json`; t3 writes settings atomically, so a live
single-file bind mount can become stale or fail when the host process renames
over the file.

## Making this reusable across projects

This is currently a **local** Feature. To reuse it across repositories, move
this folder into a dedicated Feature repo (`src/t3/`), scaffolded from
[`devcontainers/feature-starter`](https://github.com/devcontainers/feature-starter),
publish it to GHCR, and reference it as
`ghcr.io/<owner>/devcontainer-features/t3:1`. Remember to flip the published
GHCR package to **public**.
