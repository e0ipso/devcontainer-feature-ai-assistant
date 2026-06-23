# OpenCode CLI (`opencode`)

Installs the [OpenCode](https://opencode.ai/) CLI via the official shell installer.

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
- Install method: `https://opencode.ai/install` (runs as the remote user)
- Location: `~/.opencode/bin/opencode` (where the official installer puts the binary)
- `PATH` prepends `/usr/local/share/opencode-bin` (symlink to `~/.opencode/bin`) and `/usr/local/share/npm-global/bin` via feature `containerEnv`

## Options

None.

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
