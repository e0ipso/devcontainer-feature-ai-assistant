# OpenCode CLI (`opencode`)

Installs the [OpenCode](https://opencode.ai/) CLI via the [`opencode-ai`](https://www.npmjs.com/package/opencode-ai) npm package.

## Usage

Add to `.devcontainer/devcontainer.json`:

```jsonc
{
  "image": "node:24",
  "features": {
    "ghcr.io/<owner>/devcontainer-feature-ai-assistant/opencode:1": {}
  }
}
```

Replace `<owner>` with the GitHub user or org that publishes this collection.

## Requirements

- Node.js in the base image, or `ghcr.io/devcontainers/features/node` (declared via `installsAfter`).

## What it installs

- Binary: `opencode`
- Install method: `npm install -g opencode-ai`
- Location: `/usr/local/share/npm-global/bin/opencode`
- `PATH` prepends `/usr/local/share/npm-global/bin` via feature `containerEnv`

## Options

| Option | Type | Default | Description |
| ------ | ---- | ------- | ----------- |
| `updateOnPostStart` | `boolean` | `true` | Run `npm install -g opencode-ai` during the dev container `postStart` phase to update to the latest version. |

## Authentication

Run `opencode` after the container starts to sign in interactively.

## Verify

```bash
command -v opencode
```

## Local development

From this repo root:

```bash
devcontainer features test -f opencode .
```

See the [repository README](../../README.md) for publishing and combining features.
