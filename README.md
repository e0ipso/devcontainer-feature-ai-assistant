# devcontainer-feature-ai-assistant

A collection of [dev container Features](https://containers.dev/implementors/features/) that install AI coding assistant CLIs into your dev container.

| Feature | CLI installed | Published at |
| ------- | ------------- | ------------ |
| [`claude`](src/claude/README.md) | [Claude Code](https://claude.ai/) | `ghcr.io/<owner>/devcontainer-feature-ai-assistant/claude:1` |
| [`codex`](src/codex/README.md) | [OpenAI Codex CLI](https://github.com/openai/codex) | `ghcr.io/<owner>/devcontainer-feature-ai-assistant/codex:1` |
| [`copilot`](src/copilot/README.md) | [GitHub Copilot CLI](https://github.com/github/copilot-cli) | `ghcr.io/<owner>/devcontainer-feature-ai-assistant/copilot:1` |
| [`cursor`](src/cursor/README.md) | [Cursor CLI](https://cursor.com/) (`agent`) | `ghcr.io/<owner>/devcontainer-feature-ai-assistant/cursor:1` |
| [`opencode`](src/opencode/README.md) | [OpenCode](https://opencode.ai/) | `ghcr.io/<owner>/devcontainer-feature-ai-assistant/opencode:1` |
| [`t3`](src/t3/README.md) | [T3 Code](https://github.com/pingdotgg/t3code) | `ghcr.io/<owner>/devcontainer-feature-ai-assistant/t3:1` |

Replace `<owner>` with the GitHub username or org that owns this repo.

---

## Using a feature in your project

Add a `features` block to your project's `.devcontainer/devcontainer.json`:

```jsonc
{
  "image": "mcr.microsoft.com/devcontainers/base:ubuntu",
  "features": {
    // Pick one or more:
    "ghcr.io/<owner>/devcontainer-feature-ai-assistant/claude:1": {},
    "ghcr.io/<owner>/devcontainer-feature-ai-assistant/codex:1": {},
    "ghcr.io/<owner>/devcontainer-feature-ai-assistant/copilot:1": {},
    "ghcr.io/<owner>/devcontainer-feature-ai-assistant/cursor:1": {},
    "ghcr.io/<owner>/devcontainer-feature-ai-assistant/opencode:1": {},
    "ghcr.io/<owner>/devcontainer-feature-ai-assistant/t3:1": {}
  }
}
```

> **Node requirement.** The `codex`, `copilot`, and `t3` features install via npm and require Node.js in the base image (or the `ghcr.io/devcontainers/features/node` feature installed before them). The `claude`, `cursor`, and `opencode` features use shell installers that also declare `installsAfter: node` — use a Node base image or add the Node feature when composing with other features.

### Recommended base image

`node:24` or `mcr.microsoft.com/devcontainers/universal:2` cover all features out of the box.

---

## Feature details

### `claude` — Claude Code CLI

Installs the [Claude Code](https://claude.ai/) CLI (`claude`) via the official shell installer. The binary lands on a shared, user-writable npm prefix (`/usr/local/share/npm-global/bin`) so it is available to the non-root remote user at runtime.

```jsonc
"ghcr.io/<owner>/devcontainer-feature-ai-assistant/claude:1": {}
```

No options. After the container starts, run `claude` to authenticate interactively.

---

### `codex` — OpenAI Codex CLI

Installs the [Codex CLI](https://github.com/openai/codex) (`codex`) via `npm install -g @openai/codex`. Requires Node.js in the base image.

```jsonc
"ghcr.io/<owner>/devcontainer-feature-ai-assistant/codex:1": {}
```

No options. Set `OPENAI_API_KEY` in `remoteEnv`, or run `codex` interactively after the container starts to sign in.

---

### `copilot` — GitHub Copilot CLI

Installs the [`@github/copilot`](https://www.npmjs.com/package/@github/copilot) npm package globally.

```jsonc
"ghcr.io/<owner>/devcontainer-feature-ai-assistant/copilot:1": {}
```

No options. Requires Node.js in the base image. Authenticate with GitHub (`gh auth login` on the host, or inside the container). Optionally bind-mount `~/.config/gh` to reuse host credentials.

---

### `cursor` — Cursor CLI

Installs the [Cursor](https://cursor.com/) agentic CLI via the official shell installer. The installed command is `agent`, not `cursor`.

```jsonc
"ghcr.io/<owner>/devcontainer-feature-ai-assistant/cursor:1": {}
```

No options. After the container starts, run `agent login` to authenticate interactively, or set `CURSOR_API_KEY` in `remoteEnv`.

---

### `opencode` — OpenCode CLI

Installs [OpenCode](https://opencode.ai/) (`opencode`) via the official shell installer.

```jsonc
"ghcr.io/<owner>/devcontainer-feature-ai-assistant/opencode:1": {}
```

No options. After the container starts, run `opencode` to authenticate interactively.

---

### `t3` — t3 CLI

Installs the [T3 Code](https://github.com/pingdotgg/t3code) CLI globally via npm and writes a pre-seeded `settings.json` to `/usr/local/share/t3-devcontainer/settings.json` at build time. Copy or symlink that file to t3's runtime settings path in `postStartCommand` if needed. Requires Node.js in the base image.

```jsonc
"ghcr.io/<owner>/devcontainer-feature-ai-assistant/t3:1": {
  "version": "latest",
  "textGenerationModelSelectionInstanceId": "claudeAgent",
  "textGenerationModelSelectionModel": "claude-sonnet-4-6",
  "enableAssistantStreaming": true,
  "providersClaudeAgentEnabled": true,
  "providersCodexEnabled": false
}
```

See [`src/t3/devcontainer-feature.json`](src/t3/devcontainer-feature.json) for the full list of options and their defaults.

---

## Using multiple features together

Features are independent and compose freely. A typical full-stack AI setup:

```jsonc
{
  "image": "node:24",
  "features": {
    "ghcr.io/<owner>/devcontainer-feature-ai-assistant/claude:1": {},
    "ghcr.io/<owner>/devcontainer-feature-ai-assistant/t3:1": {
      "providersClaudeAgentEnabled": true,
      "textGenerationModelSelectionInstanceId": "claudeAgent"
    }
  }
}
```

Each feature prepends `/usr/local/share/npm-global/bin` to `PATH` via `containerEnv`, so extra `remoteEnv` wiring is usually unnecessary.

---

## Publishing this repo

### One-time setup

1. Fork or push this repo to GitHub.
2. In **Settings → Actions → General**, enable **Read and write permissions** for the `GITHUB_TOKEN` (the release workflow needs `packages: write` and `contents: write`).
3. If the release workflow cannot set package visibility via the API, open each package under **Packages**, go to **Package settings**, and set visibility to **Public** (required for unauthenticated `devcontainer` pulls).

### Publish features

After CI passes on `main`, the **CI** workflow publishes automatically. You can also run it manually from the Actions tab. It will:

1. Push each `src/<feature>/` directory as an OCI image to `ghcr.io/<owner>/devcontainer-feature-ai-assistant/<feature>`.
2. Attempt to set each GHCR package visibility to **public**, then verify anonymous pulls succeed.

Feature READMEs in `src/<feature>/README.md` are maintained by hand and are **not** overwritten by the release workflow.

Until the release workflow has run at least once, `ghcr.io/<owner>/devcontainer-feature-ai-assistant/<feature>:1` references will fail with "Could not resolve Feature manifest".

### Versioning

The version comes from `"version"` in each feature's `devcontainer-feature.json`. Bump it before running the release workflow to publish a new tag. Consumers pin to a major version (`:1`) to get non-breaking updates automatically.

---

## Local development & testing

### Prerequisites

```bash
npm install -g @devcontainers/cli
```

### Run all tests

```bash
# All features, all scenarios
devcontainer features test .

# One feature only
devcontainer features test -f claude .

# Specific base image
devcontainer features test -f t3 -i node:24 .
```

### Validate feature JSON

```bash
devcontainer features package -f -o /tmp/devcontainer-feature-package ./src
```

### Project structure

```
src/
  <feature>/
    devcontainer-feature.json   # metadata & options schema
    install.sh                  # runs as root during image build
    README.md                   # hand-maintained feature docs
test/
  <feature>/
    test.sh                     # default option smoke test
    scenarios.json              # named scenario matrix
  _global/
    scenarios.json              # multi-feature integration tests
.github/
  workflows/
    ci.yaml                     # validate, test, and publish to GHCR on main
  scripts/
    list-feature-ids.sh         # discover src/* feature ids
    post-publish-ghcr.sh        # set GHCR visibility public and verify pulls
```
