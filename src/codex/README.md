# Codex CLI (`codex`)

Installs the [Codex](https://chatgpt.com/codex) CLI into the dev container.

## Usage

Referenced locally from `devcontainer.json` (relative to the `.devcontainer/`
folder):

```jsonc
"features": {
  "./features/codex": {}
}
```

## Notes

- Installed to the shared npm prefix `/usr/local/share/npm-global`; add its
  `bin` to `PATH` (the project's `devcontainer.json` does this via `remoteEnv`).
- The install runs non-interactively and targets the shared npm prefix so the
  binary is visible at runtime.

## Project mounts

The project's `devcontainer.json` mounts Codex configuration read-only and seeds
credentials into a writable runtime location on start.

| Host path | Container path | Mode |
| --------- | -------------- | ---- |
| `~/.codex/prompts` | `/home/node/.codex/prompts` | read-only bind |
| `~/.codex/auth.json` | `/home/node/.cred-seed/codex/auth.json` | read-only seed bind |

`.devcontainer/scripts/seed-auth.sh` copies the credential seed bind into the
writable runtime path on container start. This keeps the host credential file
read-only while allowing Codex to update its own runtime state.

## Making this reusable across projects

This is currently a **local** Feature. To reuse it across repositories, move
this folder into a dedicated Feature repo (`src/codex/`), scaffolded from
[`devcontainers/feature-starter`](https://github.com/devcontainers/feature-starter),
publish it to GHCR, and reference it as
`ghcr.io/<owner>/devcontainer-features/codex:1`. Remember to flip the
published GHCR package to **public**.
