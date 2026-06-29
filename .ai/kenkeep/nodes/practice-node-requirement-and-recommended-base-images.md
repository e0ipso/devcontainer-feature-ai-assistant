---
schema_version: 2
id: practice-node-requirement-and-recommended-base-images
title: 'Use node:24 or universal:2 as the base image'
kind: practice
tags:
  - devcontainer
  - node
  - base-image
  - requirements
derived_from: []
relates_to: []
depends_on: []
confidence: high
summary: >-
  codex, copilot, opencode, and t3 require Node.js; claude and cursor use shell
  installers but also declare installsAfter:node.
---
Four features install via npm and require Node.js in the base image: `codex`, `copilot`, `opencode`, and `t3`. The `claude` and `cursor` features use shell installers but still declare `installsAfter: node`, so a Node base image or the `ghcr.io/devcontainers/features/node` feature is recommended even for those.

The two base images that cover all six features out of the box are `node:24` and `mcr.microsoft.com/devcontainers/universal:2`. A plain Ubuntu or Debian base image will work only for claude and cursor.
