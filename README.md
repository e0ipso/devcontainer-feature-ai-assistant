# devcontainer-feature-ai-assistant

A collection of [dev container Features](https://containers.dev/implementors/features/) that install AI coding assistant CLIs into your dev container.

| Feature | CLI installed | Published at |
| ------- | ------------- | ------------ |
| [`claude`](src/claude/README.md) | [Claude Code](https://claude.ai/) | `ghcr.io/<owner>/devcontainer-feature-ai-assistant/claude` |
| [`codex`](src/codex/README.md) | [OpenAI Codex CLI](https://github.com/openai/codex) | `ghcr.io/<owner>/devcontainer-feature-ai-assistant/codex` |
| [`copilot`](src/copilot/README.md) | [GitHub Copilot CLI](https://github.com/github/copilot-cli) | `ghcr.io/<owner>/devcontainer-feature-ai-assistant/copilot` |
| [`cursor`](src/cursor/README.md) | [Cursor CLI](https://cursor.com/) | `ghcr.io/<owner>/devcontainer-feature-ai-assistant/cursor` |
| [`opencode`](src/opencode/README.md) | [OpenCode](https://opencode.ai/) | `ghcr.io/<owner>/devcontainer-feature-ai-assistant/opencode` |
| [`t3`](src/t3/README.md) | [t3 CLI](https://t3.chat/) | `ghcr.io/<owner>/devcontainer-feature-ai-assistant/t3` |

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

> **Node requirement.** The `copilot` and `t3` features install via npm and require Node.js in the base image (or the `ghcr.io/devcontainers/features/node` feature installed before them). All other features bundle their own runtimes.

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

Installs the [Codex CLI](https://github.com/openai/codex) (`codex`) via the official shell installer.

```jsonc
"ghcr.io/<owner>/devcontainer-feature-ai-assistant/codex:1": {}
```

No options. Set `OPENAI_API_KEY` in your environment or `devcontainer.json` `remoteEnv`.

---

### `copilot` — GitHub Copilot CLI

Installs the [`@github/copilot`](https://www.npmjs.com/package/@github/copilot) npm package globally.

```jsonc
"ghcr.io/<owner>/devcontainer-feature-ai-assistant/copilot:1": {}
```

No options. Requires Node.js in the base image.

---

### `cursor` — Cursor CLI

Installs the [Cursor](https://cursor.com/) agentic CLI via the official shell installer.

```jsonc
"ghcr.io/<owner>/devcontainer-feature-ai-assistant/cursor:1": {}
```

No options.

---

### `opencode` — OpenCode CLI

Installs [OpenCode](https://opencode.ai/) (`opencode`) via the official shell installer.

```jsonc
"ghcr.io/<owner>/devcontainer-feature-ai-assistant/opencode:1": {}
```

No options.

---

### `t3` — t3 CLI

Installs the [t3](https://t3.chat/) CLI globally via npm and writes a pre-seeded `settings.json` to `/usr/local/share/t3-devcontainer/settings.json`. Your container's `postStartCommand` can copy or symlink this file to the path t3 expects.

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
  },
  "remoteEnv": {
    "PATH": "${containerEnv:PATH}:/usr/local/share/npm-global/bin"
  }
}
```

---

## Publishing this repo

### One-time setup

1. Fork or push this repo to GitHub.
2. In **Settings → Actions → General**, ensure "Read and write permissions" is enabled for the `GITHUB_TOKEN`.
3. After the first publish, go to **Packages** and set each feature package to **Public**.

### Publish features

Run the **"Release dev container features & generate documentation"** workflow from the Actions tab (or push to `main` and trigger it manually). It will:

1. Push each `src/<feature>/` directory as an OCI image to `ghcr.io/<owner>/devcontainer-feature-ai-assistant/<feature>`.
2. Auto-generate documentation into each `src/<feature>/README.md`.
3. Open a PR to commit the updated docs.

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
# Uses the devcontainers/action validator locally via the CLI
devcontainer features validate --base-path-to-features ./src
```

### Project structure

```
src/
  <feature>/
    devcontainer-feature.json   # metadata & options schema
    install.sh                  # runs as root during image build
    README.md                   # auto-updated by release workflow
test/
  <feature>/
    test.sh                     # default option smoke test
    scenarios.json              # named scenario matrix
  _global/
    scenarios.json              # multi-feature integration tests
.github/
  workflows/
    test.yaml                   # CI: runs on push / PR
    validate.yml                # CI: validates JSON schemas on PR
    release.yaml                # manual: publish to GHCR
```
