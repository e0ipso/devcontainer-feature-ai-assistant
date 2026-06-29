---
schema_version: 2
nodes_hash: 'sha256:11c8c95fc69b1027fe373256b153c90685ac824e26ff1d43e2b009aa0bc7d82b'
node_count: 14
---
# kenkeep

> kenkeep navigation: the injected body above is the root index node, the top-level catalog of branches and root-level leaves. Do not expect the whole knowledge base here; descend on demand. Read the root index node, pick one or more branches whose intent and tags match your task (several branches can be relevant), and read those branch `index.md` nodes. Descend further only where the task needs it, opening only the leaves you have confirmed are relevant. Follow each leaf's `relates_to` and `depends_on` cross edges to reach related leaves in other branches. You decide how deep to go per branch.

## Branches
_None._

## Conventions (how we build)
- Open [**All features auto-update the CLI at every postStart by default**](nodes/practice-features-auto-update-via-postupdate-on-poststart.md) to learn about: updateOnPostStart defaults to true for all features; the feature re-runs the installer or npm install at each container start to pull the latest version. #devcontainer #feature #update #poststart
- Open [**All features share /usr/local/share/npm-global/bin on PATH via containerEnv**](nodes/practice-shared-npm-global-bin-path-via-container-env.md) to learn about: Every feature prepends /usr/local/share/npm-global/bin to PATH through feature containerEnv; no extra remoteEnv wiring is needed when combining features. #devcontainer #path #npm #feature
- Open [**CI auto-publishes features to GHCR on every main push**](nodes/practice-ci-auto-publishes-features-on-main.md) to learn about: The CI workflow publishes all features as OCI images to GHCR on push to main; feature version comes from devcontainer-feature.json; consumers pin to :1 major. #devcontainer #ci #publish #ghcr #versioning
- Open [**Copilot feature authenticates via GitHub CLI; has no credential seeding**](nodes/practice-copilot-auth-via-gh-cli.md) to learn about: The copilot feature has no seedConfig or seedCredentials options; authenticate with gh auth login inside the container or bind-mount ~/.config/gh from the host. #devcontainer #copilot #auth #gotcha
- Open [**Cursor feature installs the command 'agent', not 'cursor'**](nodes/practice-cursor-cli-command-is-agent-not-cursor.md) to learn about: The cursor devcontainer feature installs the Cursor agent CLI; the binary name is 'agent', not 'cursor'. Use 'agent login' to authenticate. #devcontainer #cursor #gotcha
- Open [**Don't bind-mount a single live t3 settings file into the container**](nodes/practice-t3-avoid-single-file-bind-mount-for-settings.md) to learn about: t3 writes settings.json atomically (rename-over), so a single-file bind mount goes stale when the host process updates it; use ~/.cred-seed instead. #devcontainer #t3 #gotcha #bind-mount
- Open [**OpenCode installs from npm package 'opencode-ai', not 'opencode'**](nodes/practice-opencode-npm-package-name-is-opencode-ai.md) to learn about: The npm package for OpenCode is 'opencode-ai'; the installed binary is 'opencode'. Running npm install -g opencode would install the wrong package. #devcontainer #opencode #npm #gotcha
- Open [**seedConfig seeds config files at postStart: host mount first, then baked default**](nodes/practice-seedconfig-host-mount-then-baked-default.md) to learn about: seedConfig copies a feature config file on first postStart only if absent; host mount at ~/.cred-seed/<feature>/ wins over the image-baked default. #devcontainer #seeding #config #feature
- Open [**seedCredentials copies from host mount only; silently skips if absent**](nodes/practice-seedcredentials-host-only-no-baked-default.md) to learn about: Unlike seedConfig, seedCredentials has no image-baked fallback; it seeds auth from ~/.cred-seed/<feature>/ only and is silently skipped when that file is absent. #devcontainer #feature #seeding #credentials
- Open [**Test features locally with 'devcontainer features test'**](nodes/practice-test-features-with-devcontainers-cli.md) to learn about: Use @devcontainers/cli for local feature testing; 'devcontainer features test -f <feature> .' runs one feature's scenarios, omitting -f runs all. #devcontainer #testing #local-dev
- Open [**Use node:24 or universal:2 as the base image**](nodes/practice-node-requirement-and-recommended-base-images.md) to learn about: codex, copilot, opencode, and t3 require Node.js; claude and cursor use shell installers but also declare installsAfter:node. #devcontainer #node #base-image #requirements

## Components (what exists)
- Open [**AGENTS.md is a brief project description pointing to kenkeep ENTRY.md**](nodes/map-agents-md-placeholder.md) to learn about: AGENTS.md is a one-paragraph project overview; all navigable knowledge lives in .ai/kenkeep/ENTRY.md. #devcontainer #meta
- Open [**AI assistant devcontainer features collection**](nodes/map-ai-assistant-features-collection.md) to learn about: Six devcontainer features that install AI coding CLI tools: claude, codex, copilot, cursor, opencode, and t3. #devcontainer #feature #collection
- Open [**t3 feature is a meta-harness that orchestrates other AI providers**](nodes/map-t3-feature-is-a-meta-harness.md) to learn about: The t3 devcontainer feature installs T3 Code, a meta-harness that can route requests to Claude agent, Codex, Cursor, Grok, and OpenCode as providers. #devcontainer #t3 #meta-harness #providers
