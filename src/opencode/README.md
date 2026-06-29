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
| `seedConfig` | `boolean` | `true` | Seed `~/.config/opencode/opencode.json` on first start only (see [Configuration seeding](#configuration-seeding)). |
| `seedCredentials` | `boolean` | `true` | Seed `~/.config/opencode/auth.json` from a host mount on first start only (see [Credential seeding](#credential-seeding)). |

## Configuration seeding

On `postStart`, when `seedConfig` is enabled, the feature copies a config file into `~/.config/opencode/opencode.json` **only if that file does not already exist**, so the tool can drift afterward.

Source precedence:

1. Host seed: `~/.cred-seed/opencode/opencode.json` (bind-mount from your machine)
2. Image-baked default: `/usr/local/share/devcontainer-feature-ai-assistant/opencode/opencode.json`

The seeded file is created with mode `600`. Set `"seedConfig": false` to disable seeding.

## Credential seeding

On `postStart`, when `seedCredentials` is enabled, the feature copies the provider auth file into `~/.config/opencode/auth.json` **only if that file does not already exist** and a host seed is present. No baked default is used — if `~/.cred-seed/opencode/auth.json` is absent the step is silently skipped.

To pre-authenticate, bind-mount your host credentials directory and place your auth token at `~/.cred-seed/opencode/auth.json`.

The seeded file is created with mode `600`. Set `"seedCredentials": false` to disable.

## Authentication

Run `opencode` after the container starts to sign in interactively, or pre-authenticate via [Credential seeding](#credential-seeding).

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
