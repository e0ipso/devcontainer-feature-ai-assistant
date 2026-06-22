# Codex CLI (`codex`)

Installs the [OpenAI Codex CLI](https://github.com/openai/codex) (`codex`) via `npm install -g @openai/codex`.

## Usage

Add to `.devcontainer/devcontainer.json`:

```jsonc
{
  "image": "node:24",
  "features": {
    "ghcr.io/<owner>/devcontainer-feature-ai-assistant/codex:1": {}
  }
}
```

Replace `<owner>` with the GitHub user or org that publishes this collection.

## Requirements

- Node.js in the base image, or `ghcr.io/devcontainers/features/node` (declared via `installsAfter`).

## What it installs

- Binary: `codex`
- Location: `/usr/local/share/npm-global/bin`
- Installed as the remote (non-root) user during image build
- `PATH` is set automatically via feature `containerEnv`

## Options

None.

## Authentication

Set `OPENAI_API_KEY` in `remoteEnv`, or run `codex` interactively after the container starts to sign in.

## Verify

```bash
codex --version
```

## Local development

From this repo root:

```bash
devcontainer features test -f codex .
```

See the [repository README](../../README.md) for publishing and combining features.
