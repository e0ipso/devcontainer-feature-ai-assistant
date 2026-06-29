---
schema_version: 2
id: practice-seedcredentials-host-only-no-baked-default
title: seedCredentials copies from host mount only; silently skips if absent
kind: practice
tags:
  - devcontainer
  - feature
  - seeding
  - credentials
derived_from: []
relates_to: []
depends_on: []
confidence: medium
summary: >-
  Unlike seedConfig, seedCredentials has no image-baked fallback; it seeds auth
  from ~/.cred-seed/<feature>/ only and is silently skipped when that file is
  absent.
---
The `seedCredentials` option (default `true`) seeds the tool's auth file from the host at `postStart`, but only from a host bind-mount — there is no image-baked default fallback. If `~/.cred-seed/<feature>/auth.json` is absent, the step is silently skipped and no error is reported.

This distinguishes it from `seedConfig`, which falls back to an image-baked default when no host seed is present. With `seedCredentials`, the host file must exist for seeding to occur.

Applies to all four features that support it:
- **claude**: `~/.cred-seed/claude/.credentials.json` → `~/.claude/.credentials.json`
- **cursor**: `~/.cred-seed/cursor/auth.json` → `~/.cursor/auth.json`
- **codex**: `~/.cred-seed/codex/auth.json` → `~/.openai/auth.json`
- **opencode**: `~/.cred-seed/opencode/auth.json` → `~/.config/opencode/auth.json`

The copilot feature has no `seedCredentials` option; it uses `gh auth login` or a `~/.config/gh` bind-mount instead. Set `"seedCredentials": false` to disable.
