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

| Option | Type | Default | Description |
| ------ | ---- | ------- | ----------- |
| `updateOnPostStart` | `boolean` | `true` | Re-run the Cursor installer during the dev container `postStart` phase to update to the latest version. |
| `seedConfig` | `boolean` | `true` | Seed `~/.cursor/cli-config.json` on first start only (see [Configuration seeding](#configuration-seeding)). |
| `seedCredentials` | `boolean` | `true` | Seed `~/.cursor/auth.json` from a host mount on first start only (see [Credential seeding](#credential-seeding)). |

## Configuration seeding

On `postStart`, when `seedConfig` is enabled, the feature copies a config file into `~/.cursor/cli-config.json` **only if that file does not already exist**, so the tool can drift afterward.

Source precedence:

1. Host seed: `~/.cred-seed/cursor/cli-config.json` (bind-mount from your machine)
2. Image-baked default: `/usr/local/share/devcontainer-feature-ai-assistant/cursor/cli-config.json`

The seeded file is created with mode `600`. Set `"seedConfig": false` to disable seeding.

## Credential seeding

On `postStart`, when `seedCredentials` is enabled, the feature copies the session auth file into `~/.cursor/auth.json` **only if that file does not already exist** and a host seed is present. No baked default is used — if `~/.cred-seed/cursor/auth.json` is absent the step is silently skipped.

To pre-authenticate, bind-mount your host credentials directory and place your session token at `~/.cred-seed/cursor/auth.json`.

The seeded file is created with mode `600`. Set `"seedCredentials": false` to disable.

## Authentication

Run `agent login` after the container starts, set `CURSOR_API_KEY` in `remoteEnv`, or pre-authenticate via [Credential seeding](#credential-seeding). See [Cursor CLI configuration](https://cursor.com/docs/cli/reference/configuration) for config file locations.

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
