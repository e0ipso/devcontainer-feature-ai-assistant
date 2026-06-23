# Claude Code CLI (`claude`)

Installs the [Claude Code](https://claude.ai/) CLI into the dev container via the official shell installer.

## Usage

Add to `.devcontainer/devcontainer.json`:

```jsonc
{
  "image": "node:24",
  "features": {
    "ghcr.io/<owner>/devcontainer-feature-ai-assistant/claude:1": {}
  }
}
```

Replace `<owner>` with the GitHub user or org that publishes this collection. Pin `:1` to receive non-breaking updates on the major version.

## Requirements

- Node.js in the base image, or `ghcr.io/devcontainers/features/node` (declared via `installsAfter`).
- Recommended base images: `node:24` or `mcr.microsoft.com/devcontainers/universal:2`.

## What it installs

- Binary: `claude`
- Install method: `https://claude.ai/install.sh` (runs as the remote user)
- Location: `/usr/local/share/npm-global/bin` (symlinks from `~/.local/bin` are linked into the same prefix)
- `PATH` is set automatically via feature `containerEnv`

## Options

| Option | Type | Default | Description |
| ------ | ---- | ------- | ----------- |
| `updateOnPostStart` | `boolean` | `true` | Re-run the Claude Code installer during the dev container `postStart` phase to update to the latest version. |

## After the container starts

Run `claude` and authenticate interactively.

## Local development

From this repo root:

```bash
devcontainer features test -f claude .
```

See the [repository README](../../README.md) for publishing, combining features, and running the full test matrix.
