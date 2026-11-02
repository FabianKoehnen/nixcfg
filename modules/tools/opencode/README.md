# Shared OpenCode Home Manager configuration

Import `modules/tools/opencode` on any host that needs this shared configuration.
The Nix module `modules/tools/opencode/default.nix` is the source of managed nonsecret settings.
Home Manager generates read-only store-backed `opencode.json` and `cli.json`,
and manages individual files rather than the whole mutable directory. The shared
module also configures the existing nonsecret Playwright and disabled Home Assistant
MCP definitions and installs the Playwright wrappers and OpenCode packages. It does
not configure the removed n8n or headed-browser agents.

The shared OpenCode Ollama provider and service are opt-in together via
`services.opencode.ollama.enable = true;` (default false). The module does not
preload models. An independent host module may still enable Ollama separately; in
particular the work host already does so, with its existing CUDA settings.

**Local JSONC and cutover:** The writable local `~/.config/opencode/opencode.jsonc`
may contain credentials and overlapping MCP, provider, permission or other settings.
It has not been inspected or changed. OpenCode's effective precedence for these
files has not been verified; do not assume that duplicate names merge safely. Before
activation, privately back up the JSONC with restrictive permissions (for example,
`umask 077; cp -p ~/.config/opencode/opencode.jsonc ~/.config/opencode/opencode.jsonc.pre-hm-backup; chmod 600 ~/.config/opencode/opencode.jsonc.pre-hm-backup`).
Keep the backup outside Git and the Nix store. Privately review and reconcile all
overlapping entries and verify effective permissions, providers and MCP connections;
retain credentials only in the local JSONC. Do not copy credentials into Nix or
checked-in JSON, and do not remove entries blindly. Restore the protected backup if
verification fails. Activation and runtime verification are still pending.

Before activation, back up each existing managed target, including `cli.json`,
`AGENTS.md`, agent files and managed skill files. Check for an existing
`~/.config/opencode/opencode.json` target too; Home Manager normally refuses to
replace unmanaged files. Move only reviewed conflicting files or deliberately
configure a backup policy. Never remove the entire OpenCode directory. Managed
links are read-only; make future changes in this repository. The `playwright-cli`
skill is managed as individual files for browser automation.

The existing `~/.config/opencode/plugins/usage-budget` directory collides with
the managed directory link. Before activation, back it up separately and move the
reviewed conflicting directory aside, or deliberately configure a Home Manager
backup policy. Do not move or replace the parent `plugins` directory. The managed
subtree preserves relative imports and contains no dependencies or credentials.
V2 TUI compatibility and runtime dependency resolution have not been verified;
synthetic Node tests alone do not establish that the plugin loads in OpenCode.
