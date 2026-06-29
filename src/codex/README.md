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

| Option | Type | Default | Description |
| ------ | ---- | ------- | ----------- |
| `updateOnPostStart` | `boolean` | `true` | Run `npm install -g @openai/codex` during the dev container `postStart` phase to update to the latest version. |
| `seedConfig` | `boolean` | `true` | Seed `~/.codex/config.toml` on first start only (see [Configuration seeding](#configuration-seeding)). |

## Configuration seeding

On `postStart`, when `seedConfig` is enabled, the feature copies a config file into `~/.codex/config.toml` **only if that file does not already exist**, so the tool can drift afterward.

Source precedence:

1. Host seed: `~/.cred-seed/codex/config.toml` (bind-mount from your machine)
2. Image-baked default: `/usr/local/share/devcontainer-feature-ai-assistant/codex/config.toml`

The seeded file is created with mode `600`. Set `"seedConfig": false` to disable seeding.

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
