# Cursor CLI (`cursor`)

Installs the [Cursor](https://cursor.com/) CLI (`agent`) into the dev container.

## Usage

Referenced locally from `devcontainer.json` (relative to the `.devcontainer/`
folder):

```jsonc
"features": {
  "./features/cursor": {}
}
```

## Notes

- Installed to the user's local bin and a shared, user-writable npm prefix
  (`/usr/local/share/npm-global`). Add both to `PATH` (the project's
  `devcontainer.json` does this via `remoteEnv`).
- The installer runs as the remote (non-root) user so artifacts are visible at
  runtime rather than landing in root's home.
- The installed command is `agent` rather than `cursor`.

## Project mounts

The project's `devcontainer.json` mounts Cursor configuration read-only and seeds
credentials into a writable runtime location on start.

| Host path | Container path | Mode |
| --------- | -------------- | ---- |
| `~/.cursor/cli-config.json` | `/home/node/.cursor/cli-config.json` | read-only bind |
| `~/.config/cursor/auth.json` | `/home/node/.cred-seed/cursor/auth.json` | read-only seed bind |

`.devcontainer/scripts/seed-auth.sh` copies the credential seed bind into the
writable runtime path on container start. This keeps the host credential file
read-only while allowing Cursor to update its own runtime state.

## Making this reusable across projects

This is currently a **local** Feature. To reuse it across repositories, move
this folder into a dedicated Feature repo (`src/cursor/`), scaffolded from
[`devcontainers/feature-starter`](https://github.com/devcontainers/feature-starter),
publish it to GHCR, and reference it as
`ghcr.io/<owner>/devcontainer-features/cursor:1`. Remember to flip the
published GHCR package to **public**.
