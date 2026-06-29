---
schema_version: 2
id: practice-cursor-cli-command-is-agent-not-cursor
title: 'Cursor feature installs the command ''agent'', not ''cursor'''
kind: practice
tags:
  - devcontainer
  - cursor
  - gotcha
derived_from: []
relates_to: []
depends_on: []
confidence: high
summary: >-
  The cursor devcontainer feature installs the Cursor agent CLI; the binary name
  is 'agent', not 'cursor'. Use 'agent login' to authenticate.
---
The Cursor devcontainer feature installs the Cursor agent CLI via the official shell installer. Despite the feature being named `cursor`, the installed binary is `agent`, not `cursor`. Run `command -v agent` (not `command -v cursor`) to verify the install.

Authenticate with `agent login`, or set `CURSOR_API_KEY` in `remoteEnv`, or use seedCredentials to pre-populate `~/.cursor/auth.json` from a host mount.
