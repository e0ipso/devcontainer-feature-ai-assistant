# GitHub Copilot CLI (`copilot`)

Installs the [GitHub Copilot](https://github.com/features/copilot) CLI into the
dev container.

## Usage

Referenced locally from `devcontainer.json` (relative to the `.devcontainer/`
folder):

```jsonc
"features": {
  "./features/copilot": {}
}
```

## Notes

- Installed to the shared npm prefix `/usr/local/share/npm-global`; add its
  `bin` to `PATH` (the project's `devcontainer.json` does this via `remoteEnv`).
- The install runs as the remote (non-root) user so the binary is visible at
  runtime rather than landing in root's home.
- Authentication relies on the GitHub CLI (`gh`) being logged in. The project's
  `devcontainer.json` mounts `~/.config/gh/hosts.yml` for this.

## Project mounts

The project's `devcontainer.json` mounts Copilot configuration read-only.

| Host path | Container path | Mode |
| --------- | -------------- | ---- |
| `~/.copilot/config.json` | `/home/node/.copilot/config.json` | read-only bind |
| `~/.copilot/hooks` | `/home/node/.copilot/hooks` | read-only bind |

## Making this reusable across projects

This is currently a **local** Feature. To reuse it across repositories, move
this folder into a dedicated Feature repo (`src/copilot/`), scaffolded from
[`devcontainers/feature-starter`](https://github.com/devcontainers/feature-starter),
publish it to GHCR, and reference it as
`ghcr.io/<owner>/devcontainer-features/copilot:1`. Remember to flip the
published GHCR package to **public**.
