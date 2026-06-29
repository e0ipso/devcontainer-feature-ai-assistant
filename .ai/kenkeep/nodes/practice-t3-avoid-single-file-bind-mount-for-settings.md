---
schema_version: 2
id: practice-t3-avoid-single-file-bind-mount-for-settings
title: Don't bind-mount a single live t3 settings file into the container
kind: practice
tags:
  - devcontainer
  - t3
  - gotcha
  - bind-mount
derived_from: []
relates_to: []
depends_on: []
confidence: high
summary: >-
  t3 writes settings.json atomically (rename-over), so a single-file bind mount
  goes stale when the host process updates it; use ~/.cred-seed instead.
---
Do not bind-mount your live desktop `~/.t3/userdata/settings.json` directly as a single-file read-only mount into the container. T3 writes `settings.json` atomically via rename-over, which means the host process replaces the file inode when saving; a single-file bind mount points to the original inode and silently goes stale after the first host save.

Instead, use the `seedConfig` mechanism: place your desired starting settings at `~/.cred-seed/t3/settings.json` on the host and bind-mount the entire `~/.cred-seed` directory. The feature will copy it on first `postStart` only if `$T3CODE_HOME/userdata/settings.json` is absent.
