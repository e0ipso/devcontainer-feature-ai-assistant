# Cursor CLI (command: `agent`)

Installs the [Cursor](https://cursor.com/) agent CLI via the official shell installer.

## Usage

Add to `.devcontainer/devcontainer.json`:

```jsonc
{
  "image": "node:24",
  "features": {
    "ghcr.io/<owner>/devcontainer-feature-ai-assistant/cursor:1": {}
  }
}
```

Replace `<owner>` with the GitHub user or org that publishes this collection.

## Requirements

- Node.js in the base image, or `ghcr.io/devcontainers/features/node` (declared via `installsAfter`).

## What it installs

- Command: `agent` (not `cursor`)
- Install method: `https://cursor.com/install` (runs as the remote user)
- Location: `/usr/local/share/npm-global/bin` (symlinks from `~/.local/bin` are linked into the same prefix)
- `PATH` is set automatically via feature `containerEnv`

## Options

None.

## Authentication

Run `agent login` after the container starts, or set `CURSOR_API_KEY` in `remoteEnv`. See [Cursor CLI configuration](https://cursor.com/docs/cli/reference/configuration) for config file locations.

## Verify

```bash
command -v agent
```

## Local development

From this repo root:

```bash
devcontainer features test -f cursor .
```

See the [repository README](../../README.md) for publishing and combining features.
