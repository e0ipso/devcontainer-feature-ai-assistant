---
schema_version: 2
id: practice-seedconfig-host-mount-then-baked-default
title: >-
  seedConfig seeds config files at postStart: host mount first, then baked
  default
kind: practice
tags:
  - devcontainer
  - seeding
  - config
  - feature
derived_from: []
relates_to: []
depends_on: []
confidence: high
summary: >-
  seedConfig copies a feature config file on first postStart only if absent;
  host mount at ~/.cred-seed/<feature>/ wins over the image-baked default.
---
The `seedConfig` option (default `true`) seeds the tool's config file on `postStart` **only if the target file does not already exist**, so the tool can drift after the first start. Source precedence:

1. Host seed: `~/.cred-seed/<feature>/<config-file>` (bind-mount from your machine)
2. Image-baked default: `/usr/local/share/devcontainer-feature-ai-assistant/<feature>/<config-file>`

The seeded file is created with mode `600`. Set `"seedConfig": false` to disable seeding entirely.

Applies to claude (`~/.claude/settings.json`), codex (`~/.codex/config.toml`), cursor (`~/.cursor/cli-config.json`), opencode (`~/.config/opencode/opencode.json`), and t3 (`$T3CODE_HOME/userdata/settings.json`). Also documented in `src/codex/README.md`, `src/cursor/README.md`, `src/opencode/README.md`, and `src/t3/README.md`.
