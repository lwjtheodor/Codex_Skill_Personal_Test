---
name: ccfep-completion-watcher
description: Use when the user wants to keep checking whether a CCFEP task has finished. Typical requests include "watch this job until it completes", "check whether this task is done yet", "poll this run every so often", or "if it finishes, prepare the next step automatically."
---

# CCFEP Completion Watcher

Use this skill to define a short, repeatable watch pass over a task.

This skill is designed for automation cadence, not for occupying a conversation thread.

It should decide:

- what object is being watched
- which evidence sources should be checked
- what counts as completed
- what compact status to emit if still pending
- what downstream artifact to draft once completed

## Preferred evidence

- one concrete task manifest or task reference
- output contract from `ccfep-task-output-contract`
- input object from `ccfep-workstream-input-builder` when the watch scope depends on rule-built selectors
- local receipts under `E:/ssh_scp/runtime/state/`
- cluster state snapshots or event log
- remote path inspection only when local evidence is insufficient
- discovery results from `ccfep-workstream-protocol`

## Contract-first boundary

- default to manifests, task output contracts, input-builder objects, receipts, cluster state, and protocol discovery
- do not inspect Python implementation files unless contract or README evidence is insufficient
- prefer output contracts, manifests, execution maps, and agent README over executor source
- if resource snapshots or locators are insufficient, emit `resource_lookup_needed`
- escalate as `implementation_lookup_needed` instead of reading code by default

## Layer and authoring rule

- never create a new script in this skill
- never modify executor implementation in this skill
- if script authoring seems required, hand off to `ccfep-workstream-coder`

## Best fit

Use this skill when the user wants workflows like:

- "submit, then wait until finished, then fetch"
- "check this task every hour"
- "tell me if it is done yet"
- "if complete, draft the next manifest automatically"

## When not to use

- do not use for one-shot state summaries with no watch intent; use `ccfep-workstream-report`
- do not use as a permanent daemon design
- do not use when completion criteria are still undefined; first derive them with `ccfep-task-output-contract`

## Minimal output schema

```json
{
  "watch_scope": "",
  "observed_status": "pending | running | completed | failed | uncertain",
  "evidence_checked": [],
  "completion_basis": [],
  "next_check_hint": "",
  "pending_status": "",
  "completion_event": null,
  "downstream_action": "fetch_results | workstream_report | handoff_review | none",
  "downstream_draft": null
}
```

## Path/file-level expected output

- default inline product: one watch-pass record
- if materialized locally, write to `E:/ssh_scp/runtime/skills/ccfep/completion_watcher/<watch_slug>.json`
- `evidence_checked` should list concrete local files first: `E:/ssh_scp/runtime/state/cluster_state.json`, `E:/ssh_scp/runtime/state/cluster_event_log.jsonl`, and matching receipt files under `E:/ssh_scp/runtime/state/`
- if remote inspection is needed, include the absolute remote root and the exact file or file pattern checked under `/lustre/home/users/ewu/...`
- `completion_basis` must cite auditable file or state evidence, not only a prose conclusion
- when `downstream_draft` is non-null, it should point to one materializable draft path such as `E:/ssh_scp/runtime/skills/ccfep/workstream_report/<watch_slug>.json` or `E:/ssh_scp/runtime/skills/ccfep/event_to_manifest/<watch_slug>.manifest.json`

## Watch procedure

1. identify the concrete watch target
2. load or derive the output contract
3. check local receipts and cluster state first
4. inspect remote outputs only when local evidence is incomplete
5. compare observed evidence against completion criteria
6. emit either a compact pending status or a completion event with downstream draft

## Pending-output rule

If the task is not complete, keep the output small and operational.

Preferred pending content:

- current observed phase
- most recent evidence
- missing completion evidence
- suggested next check timing

Do not emit a large narrative status dump unless the user asked for depth.

## Completion-output rule

When completion is established:

- state the narrow completion basis
- choose the default downstream action from the output contract
- draft the next object only if there is enough evidence
- prefer `fetch_results` when remote outputs are fetch-worthy and not yet local
- otherwise prefer `workstream_report`

If routing is ambiguous, emit `handoff_review` instead of inventing a confident follow-up.

## Automation rule

This skill is a strong fit for Codex automations.

When used with automation:

- keep each run idempotent
- avoid long-running waits inside one invocation
- treat each run as one inspection pass
- return inbox-friendly output that can be archived when nothing actionable changed

## Cadence rule

Choose cadence from task cost and volatility, not from user impatience.

Prefer language such as:

- frequent checks for short queue or short executor tasks
- slower checks for expensive remote jobs

If the user gives a cadence, use it. If not, recommend a conservative default and record that assumption.

## Shared discovery rule

Reuse:

- `ccfep-task-output-contract` for completion criteria and downstream bias
- `ccfep-workstream-report` for compact observational summaries
- `ccfep-event-to-manifest` when a completion event should become a downstream manifest
- `ccfep-handoff-planner` when multiple post-completion routes remain possible

Do not duplicate workstream routing tables inside this skill.

## Ambiguity handling rule

- if evidence conflicts, mark `observed_status` as `uncertain`
- if completion is plausible but not auditable, stay pending and name the missing proof
- if remote inspection is unavailable, report based on local evidence and say so explicitly
