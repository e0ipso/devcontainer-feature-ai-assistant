---
schema_version: 2
id: map-ai-assistant-features-collection
title: AI assistant devcontainer features collection
kind: map
tags:
  - devcontainer
  - feature
  - collection
derived_from: []
relates_to: []
depends_on: []
confidence: high
summary: >-
  Six devcontainer features that install AI coding CLI tools: claude, codex,
  copilot, cursor, opencode, and t3.
---
This repo publishes six devcontainer features, each installing one AI coding CLI into the container:

- **claude** — Claude Code CLI (`claude`), via shell installer
- **codex** — OpenAI Codex CLI (`codex`), via npm (`@openai/codex`)
- **copilot** — GitHub Copilot CLI (`copilot`), via npm (`@github/copilot`)
- **cursor** — Cursor agent CLI (`agent`), via shell installer
- **opencode** — OpenCode CLI (`opencode`), via npm (`opencode-ai`)
- **t3** — T3 Code CLI (`t3`), via npm; a meta-harness that routes to the others

Features are independent and compose freely. All binaries land in `/usr/local/share/npm-global/bin`, which is added to `PATH` via `containerEnv`.
