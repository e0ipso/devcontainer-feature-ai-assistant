# Claude Code CLI (`claude`)

Installs the [Claude Code](https://claude.ai/) CLI into the dev container.

## Usage

Referenced locally from `devcontainer.json` (relative to the `.devcontainer/`
folder):

```jsonc
"features": {
  "./features/claude": {}
}
```

## Notes

- Installed to the user's local bin and a shared, user-writable npm prefix
  (`/usr/local/share/npm-global`). Add both to `PATH` (the project's
  `devcontainer.json` does this via `remoteEnv`).
- The installer runs as the remote (non-root) user so artifacts are visible at
  runtime rather than landing in root's home.

## Project mounts

The project's `devcontainer.json` mounts Claude configuration read-only and seeds
credentials into a writable runtime location on start.

| Host path | Container path | Mode |
| --------- | -------------- | ---- |
| `~/.claude/.credentials.json` | `/home/node/.cred-seed/claude/.credentials.json` | read-only seed bind |
| `~/.claude/CLAUDE.md` | `/home/node/.claude/CLAUDE.md` | read-only bind |
| `~/.claude.json` | `/home/node/.claude.json` | read-only bind |
| `~/.claude/settings.json` | `/home/node/.claude/settings.json` | read-only bind |
| `~/.claude/skills` | `/home/node/.claude/skills` | read-only bind |
| `~/.claude/hooks` | `/home/node/.claude/hooks` | read-only bind |
| `~/.claude/commands` | `/home/node/.claude/commands` | read-only bind |

`.devcontainer/scripts/seed-auth.sh` copies the credential seed bind into the
writable runtime path on container start. This keeps the host credential file
read-only while allowing Claude Code to update its own runtime state.

## Making this reusable across projects

This is currently a **local** Feature. To reuse it across repositories, move
this folder into a dedicated Feature repo (`src/claude/`), scaffolded from
[`devcontainers/feature-starter`](https://github.com/devcontainers/feature-starter),
publish it to GHCR, and reference it as
`ghcr.io/<owner>/devcontainer-features/claude:1`. Remember to flip the
published GHCR package to **public**.
