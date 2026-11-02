# Connection mapping

This file contains routing references only, never credentials. Connection approval is temporary conversation state, not a setting in this file.

## Default: subscription

Provider ID: `openai`.

Edit the default model/variant assignments in `modules/tools/opencode/default.nix` relative to the configuration repository root. Home Manager deploys `~/.config/opencode/opencode.json` as a read-only store-backed file; writable local `~/.config/opencode/opencode.jsonc` retains private MCP and provider settings; review overlaps with shared definitions before cutover. The three worker assignments are under `agents.worker-small.model`, `agents.worker-medium.model`, and `agents.worker-complex.model`. Keep them on the subscription provider. New conversations always start with this route, regardless of API approval in an earlier conversation.

## Paid API: explicit permission required

Provider ID: `openai-api` (display name: OpenAI (API Key)).

| Worker role | Per-call API model override |
| --- | --- |
| `worker-small` | `openai-api/gpt-6-luna#high` |
| `worker-medium` | `openai-api/gpt-6.1-terra#low` |
| `worker-complex` | `openai-api/gpt-6.1-sol#low` |

To change an API assignment, edit its row here using a verified `provider/model#variant` reference. Keep the same category and reasoning variant as the subscription assignment unless the user requests a change. When adding an API model to OpenCode's provider catalog is necessary, obtain approval first; do not read or change credentials.

Example: “Use the API now” allows these overrides for the current conversation and its child tasks only. It does not change default agents, authorize different models or variants, or approve API use in future conversations. “Use the subscription again” ends the API authorization.
