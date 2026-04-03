---
name: ccfep-handoff-planner
description: Use when the user wants to know what should happen next for a CCFEP task. Typical requests include "should this wait or retry", "what is the next action here", "should I fetch, inspect, or hand this off", "should I upload the new script version first", "after syncing this analysis script, what should run next", or "where should this task go next."
---

# CCFEP Handoff Planner

Use this skill when the main question is what should happen next, not how to directly execute a command.

## Preferred evidence

- normalized request object from `ccfep-request-normalizer`
- local receipts under `E:/ssh_scp/runtime/state/`
- current task record or manifest
- workstream execution maps
- compact report or case-state summary
- discovery results from `ccfep-workstream-protocol`
- task output contract from `ccfep-task-output-contract` when completion or fetch-worthiness drives the decision

## Contract-first boundary

- default to normalized request objects, reports, manifests, execution maps, output contracts, and agent README boundaries
- do not inspect Python implementation files unless contract or README evidence is insufficient
- prefer specs, path families, execution maps, task output contracts, and agent README over executor source
- if resource snapshots or locators are insufficient, emit `resource_lookup_needed`
- escalate as `implementation_lookup_needed` instead of reading code by default

## Layer and authoring rule

- never create a new script in this skill
- never modify executor implementation in this skill
- if script authoring seems required, hand off to `ccfep-workstream-coder`

## When not to use

- do not use when the user only wants raw inspection output
- do not use when the next action is already explicitly specified and no routing is needed
- do not use as a replacement for manifest drafting

## Minimal output schema

```json
{
  "request_ref": "",
  "scope": "",
  "decision": "wait | retry | inspect | fetch | review | handoff",
  "target": "",
  "reason": "",
  "required_artifacts": []
}
```

## Path/file-level expected output

- default inline product: one handoff decision record
- if materialized locally, write to `E:/ssh_scp/runtime/skills/ccfep/handoff_planner/<scope_slug>.json`
- `scope` should be an absolute remote path or a concrete local artifact path
- `required_artifacts` must be path/file oriented entries such as a local receipt under `E:/ssh_scp/runtime/state/`, a local draft under `E:/ssh_scp/runtime/skills/ccfep/...`, or a remote file pattern under `/lustre/home/users/ewu/...`
- when `decision=handoff`, `target` should name both the downstream consumer and the expected artifact path it should receive or produce
- when `decision=fetch` or `decision=inspect`, the rationale should cite the exact missing or expected path/file basis

## Ambiguity handling rule

- if downstream target is ambiguous, return `decision=review` or `decision=inspect`
- do not route to a destructive or high-cost executor when evidence is incomplete

## Shared discovery rule

Do not encode separate workstream routing logic here.

Reuse protocol-layer discovery for:

- workstream registration state
- path family
- capability route
- missing implementation detection

Reuse request-normalizer outputs for:

- stable scope and marker extraction
- downstream skill or agent hints
- explicit ambiguity carry-through

## Decision outputs

- wait
- retry
- inspect
- fetch
- review
- handoff to downstream executor

## Preferred evidence

- local receipts under `E:/ssh_scp/runtime/state/`
- workstream execution maps
- compact status reports

Keep the result as a small handoff record with explicit rationale.

When the input is a normalized request object, do not restate free-form intent in new words unless needed for the decision rationale.
