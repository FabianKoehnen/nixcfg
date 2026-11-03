---
name: delegating-by-complexity
description: Use when handling nontrivial user problems, multi-step work, coding, testing, large-context research, or difficult planning and diagnosis in OpenCode, especially under time pressure or when many tool roundtrips are expected.
---

# Delegating by complexity

The parent coordinates; workers perform bounded tasks. Actively look for useful decomposition before doing substantial work yourself. Preserve user approvals, required skills, and project safety rules.

## Cost priority

Prefer the smallest worker capable of meeting the acceptance criteria. Choose based on the reasoning required, not arbitrary frequency restrictions. More context or roundtrips alone do not justify a larger worker. Normal coding remains medium work; never force a task onto an incapable worker to satisfy a quota. Escalate with evidence when the current worker hits a real reasoning limit rather than repeating unsuccessful attempts indefinitely.

## Subscription budget

Before dispatching subscription workers, discover and call the `usage_budget` Code Mode tool. It returns primary and secondary windows, remaining percentages, reset times, time-adjusted offsets and severity (`normal`, `warning`, `critical`, or `unknown`), capture time, and completeness. Evaluate each window independently and use the returned severity; do not infer it from the remaining percentage. Refresh before additional dispatches; the tool caches briefly and invalidates at reset. Treat missing, partial, expired, failed, or unknown-severity data as unknown. Do not reveal credentials or raw provider responses.

By default, for complete, fresh data, if either window has `warning` or `critical` severity, ask the user which agent to use before dispatching a medium or complex worker for the task. Recommend an appropriate agent and briefly explain why. Do not substitute frequency restrictions for the user's decision. If data is unknown, explain and ask before using medium or complex workers. If the user explicitly authorizes using other agents without asking for the current task, select an appropriate agent without this budget-related question, including when severity is unknown. Approval applies only to its stated scope, not as a permanent exemption. Small workers may always be used without a budget-related approval, regardless of severity or missing data. If an actual quota or rate limit blocks work, stop and ask; never switch to the paid API without explicit authorization. These are agent instructions, not a technical billing or access enforcement mechanism.

## Routing

| Agent | Work |
| --- | --- |
| `worker-small` | Repetitive tests, bounded probes, broad inventory, large-context extraction, mechanical work; many roundtrips are acceptable. |
| `worker-medium` | Normal coding, routine fixes, regression-test authoring, and clear implementation briefs; supply enough context to avoid clarification loops. |
| `worker-complex` | Difficult planning, architecture, novel root-cause reasoning; returns decisions, probe requests, and implementation briefs, not routine code. |

### Worker aliases

The worker classes may also be referred to by these aliases:

| Alias | Worker class |
| --- | --- |
| `Luna` | `worker-small` |
| `Terra` | `worker-medium` |
| `Sol` | `worker-complex` |

Treat an alias as the corresponding worker class when interpreting a request or discussing delegation. Use the canonical worker name (`worker-small`, `worker-medium`, or `worker-complex`) when selecting an agent for a tool call; aliases do not change the configured agent or its model.

Choose by reasoning difficulty, not input length or tool-call count. Complex diagnosis with many calls becomes complex reasoning plus small-worker evidence gathering. Medium workers may run focused checks during coding; broad test execution goes to small workers. Difficult test design is not mechanical test execution.

## Coordination

When a substantial task has unclear decomposition, dependencies, or worker allocation, the parent may consult `delegation-advisor` for recommendations if its medium-tier budget rules permit. Skip the advisor for trivial or already clear splits. Provide the task, relevant constraints, and current normalized budget status; the advisor cannot dispatch workers or modify files. The parent retains decisions, dispatch, and verification. The advisor uses the same budget and approval rules as `worker-medium`, including for unknown or low balances.

1. Identify deliverables, dependencies, evidence needs, and file ownership. Actively decompose substantial work into useful independent units to maximize safe parallel work. Briefly state the split and category choices. Answer trivial questions directly; do not manufacture subtasks.
2. Start independent units concurrently when worthwhile, accounting for costs and coordination overhead; sequence dependent work. Track background tasks and collect their results before relying on them, starting dependent work, or claiming completion. Do not duplicate delegated work while waiting.
3. Give each worker: objective, relevant context/evidence, checkout and allowed paths, edit permissions, acceptance criteria, required skills/commands, and expected output. Transfer material context explicitly: child sessions start fresh. Never transfer secrets.
4. Keep one write-capable agent per checkout when project rules require it; otherwise ensure disjoint ownership. Readers and tests must also wait if concurrent edits would invalidate their evidence. Never revert another worker's changes.
5. Complex workers request bounded small-worker probes through the parent. Parent returns evidence to the existing complex session, then sends its implementation brief to medium. Avoid nesting or routing routine coding back to complex.
6. Review results and evidence, resolve conflicts, arrange required verification, and report actual outcomes. Reuse child sessions for related follow-up; avoid repeatedly resending the full context.

## Model configuration

Default to the subscription connection and use the named agents without a model override. The editable global subscription mapping lives in `modules/tools/opencode/default.nix` relative to the configuration repository root; Home Manager deploys it as read-only store-backed `~/.config/opencode/opencode.json`, while writable local `~/.config/opencode/opencode.jsonc` retains private MCP and provider settings; review overlaps with shared definitions before cutover. The mapping is under `agents.worker-small.model`, `agents.worker-medium.model`, `agents.worker-complex.model`, and `agents.delegation-advisor.model`. Keep the advisor model and variant aligned with worker-medium when changing either. Do not duplicate those model IDs here or in agent Markdown files. Check effective project overrides: they do not grant permission to use a paid API connection.

### Subscription versus paid API

Read [connections.md](connections.md) for connection IDs and the separately maintained API mapping. Start each new conversation in subscription-only mode. Subscription quota exhaustion, a rate limit, or an API connection being configured is NOT permission to incur API charges: stop affected work, report the blocker, and ask.

An explicit user instruction such as “use the API now” authorizes API use only in the current parent conversation and its delegated tasks. Record that authorization in handoff/continuation summaries, not global files. Do not carry it into unrelated or new conversations; a user revocation ends it immediately.

With that authorization, keep the same worker roles and pass the exact API model/variant from connections.md as a per-call model override. This is the sole connection-switch exception to the no-overrides rule. Verify the reference is available before dispatch; include the active connection and authorization in the brief. Do not change global defaults, credentials, or provider configuration. For an existing child session, verify the override takes effect; otherwise start a fresh child with a concise handoff. If the parent session itself cannot continue through the subscription, the user must select an API model for that session; this skill cannot switch its own running model.

API permission is not permission to change category, model, or reasoning variant. An unmapped/unavailable category remains blocked until the user chooses a replacement. Never invent an API model ID or silently route medium work to complex. Do not make paid API calls merely to test these rules.

If an agent or configured model is unavailable, report the blocker and ask before substituting. Do not silently inherit the parent's model, upgrade variants, or retry indefinitely. If the tool catalog cannot call the configured agents, explain that limitation rather than pretending a generic worker is equivalent.

## Example

A race condition plus an unrelated UI change: complex analyzes the race; small collects requested traces; medium implements the agreed UI change. After diagnosis, medium fixes the race; small runs the relevant suite against stable code. Parent reviews and integrates.

## Common mistakes

| Temptation | Correction |
| --- | --- |
| “Many calls require the strongest model.” | Split reasoning from mechanical evidence gathering. |
| “A larger worker saves some roundtrips.” | Prefer the smallest capable worker; roundtrip count is not reasoning difficulty. |
| “The subscription is exhausted, so use the API.” | Explicit permission in this conversation is required. |
| “The authorized model is unavailable; substitute automatically.” | Ask before changing the configured model. |
| “I already know the context, so I should do everything.” | Send a sufficient brief and retain coordination. |
| “Testing belongs entirely to small.” | Medium authors ordinary regression tests and performs necessary focused checks. |

Red flags: complex doing routine coding, simultaneous conflicting writes, silent model changes, or verification claims without evidence. Stop and correct the allocation.
