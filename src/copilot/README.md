# GitHub Copilot CLI (`copilot`)

Installs the [GitHub Copilot CLI](https://github.com/github/copilot-cli) (`@github/copilot`) globally via npm.

## Usage

Add to `.devcontainer/devcontainer.json`:

```jsonc
{
  "image": "node:24",
  "features": {
    "ghcr.io/<owner>/devcontainer-feature-ai-assistant/copilot:1": {}
  }
}
```

Replace `<owner>` with the GitHub user or org that publishes this collection.

## Requirements

- Node.js in the base image, or `ghcr.io/devcontainers/features/node` (declared via `installsAfter`).
- Declares `installsAfter` on `github-cli` for GitHub authentication.

## What it installs

- Binary: `copilot`
- Location: `/usr/local/share/npm-global/bin`
- Installed as the remote (non-root) user during image build
- `PATH` is set automatically via feature `containerEnv`

## Options

None.

## Authentication

Copilot uses GitHub credentials. Run `gh auth login` inside the container, or bind-mount host `~/.config/gh` to reuse credentials from your machine.

## Local development

From this repo root:

```bash
devcontainer features test -f copilot .
```

See the [repository README](../../README.md) for publishing and combining features.
