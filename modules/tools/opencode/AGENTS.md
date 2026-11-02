# Global preferences

## Browser automation

- For browser automation and interactive page inspection, use the `playwright-cli` skill when available. Follow its
  installation and browser-session guidance; do not install another CLI copy through npm or npx.
- Project-specific instructions take precedence for execution location, authentication, and sensitive data. Do not
  assume permission to access authenticated pages or persist browser state.

## Task delegation

- For nontrivial work, load `delegating-by-complexity` before substantial investigation or implementation. Actively split useful tasks among `worker-small`, `worker-medium`, and `worker-complex`; keep coordination and integration in the parent. Answer trivial requests directly.
- Prefer the smallest capable worker: small frequently, medium selectively, complex rarely; larger workers cost more. Do not upgrade merely for more context or tool roundtrips.
- Default agent models and variants are edited in `modules/tools/opencode/default.nix` relative to the configuration repository root. Home Manager deploys `~/.config/opencode/opencode.json` as a read-only store-backed file; the writable local `~/.config/opencode/opencode.jsonc` retains private MCP and provider settings; review overlaps with shared definitions before cutover. Use the subscription connection by default; quota exhaustion never authorizes a paid API fallback.
- Only an explicit user instruction in the current conversation permits paid API overrides from the skill's `connections.md`. That approval applies to this conversation and its child tasks only, never future conversations. Keep global defaults unchanged; ask before substituting an unmapped model or variant. This is the only connection-switch exception to the no-model-overrides rule.

## Atlassian

- Keep the Atlassian MCP available. Jira, Confluence and other requested Atlassian operations may be used normally.
- Do not use Atlassian Artifacts, upload files to it, or suggest or ask about Artifacts uploads unless the user explicitly requests that feature.
- Keep generated plans and documentation in local files or the repository as appropriate; do not offer to publish them to Atlassian Artifacts.
- Add the label `ki-generiert` to Jira tickets created by OpenCode. Do not automatically add it when updating existing tickets; preserve existing labels.
- Consider a useful categorization for Jira tickets, such as an existing epic, component, or topical label. Suggest appropriate groupings to the user when helpful; do not create epics or change existing assignments without authorization.
