# OpenCode CLI (`opencode`)

Installs the [OpenCode](https://opencode.ai/) CLI into the dev container.

## Usage

Referenced locally from `devcontainer.json` (relative to the `.devcontainer/`
folder):

```jsonc
"features": {
  "./features/opencode": {}
}
```

## Notes

- Installed to the user's local bin and a shared, user-writable npm prefix
  (`/usr/local/share/npm-global`). Add both to `PATH` (the project's
  `devcontainer.json` does this via `remoteEnv`).
- The installer runs as the remote (non-root) user so artifacts are visible at
  runtime rather than landing in root's home.

## Project mounts

The project's `devcontainer.json` keeps OpenCode runtime state writable while
seeding credentials from a read-only host copy.

| Host path or volume | Container path | Mode |
| ------------------- | -------------- | ---- |
| `~/.config/opencode/opencode.jsonc` | `/home/node/.config/opencode/opencode.jsonc` | read-only bind |
| `~/.config/opencode/plugin` | `/home/node/.config/opencode/plugin` | read-only bind |
| `~/.config/opencode/node_modules` | `/home/node/.config/opencode/node_modules` | read-only bind |
| `~/.cache/opencode` | `/home/node/.cache/opencode` | writable bind |
| `opencode-data-${devcontainerId}` | `/home/node/.local/share/opencode` | writable volume |
| `~/.local/share/opencode/auth.json` | `/home/node/.cred-seed/opencode/auth.json` | read-only seed bind |

`.devcontainer/scripts/seed-auth.sh` copies the credential seed bind into the
writable runtime path on container start. This keeps the host credential file
read-only while allowing OpenCode to update its own runtime state.

## Making this reusable across projects

This is currently a **local** Feature. To reuse it across repositories, move
this folder into a dedicated Feature repo (`src/opencode/`), scaffolded from
[`devcontainers/feature-starter`](https://github.com/devcontainers/feature-starter),
publish it to GHCR, and reference it as
`ghcr.io/<owner>/devcontainer-features/opencode:1`. Remember to flip the
published GHCR package to **public**.
