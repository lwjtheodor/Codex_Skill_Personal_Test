---
name: ccfep-workstream-report
description: Use when the user wants a compact update on what is happening in a CCFEP workstream right now. Typical requests include "summarize the current state", "what is going on with this workstream", "give me a status report for this branch", "has this analysis started yet", "what changed after I synced the remote scripts", or "show the latest evidence and next step without drafting a manifest."
---

# CCFEP Workstream Report

Use this skill to turn local receipts and inspected remote state into a compact status report.

## Preferred anchors

- `E:/ssh_scp/runtime/state/cluster_event_log.jsonl`
- `E:/ssh_scp/runtime/state/cluster_state.json`
- `E:/ssh_scp/docs/ccfep_cluster_control_reuse.json`

## Preferred evidence

- normalized request object from `ccfep-request-normalizer` when the report is being requested from descriptive text
- local receipts first
- task records emitted by workstream executors
- remote path listings only when local evidence is insufficient
- discovery results from `ccfep-workstream-protocol`
- output contracts from `ccfep-task-output-contract` when expected artifacts or completion clues are needed

## Contract-first boundary

- default to receipts, cluster state, protocol discovery, task manifests, task output contracts, and agent README evidence
- do not inspect Python implementation files unless contract or README evidence is insufficient
- prefer specs, path families, execution maps, task output contracts, and agent README over executor source
- if resource snapshots or locators are insufficient, emit `resource_lookup_needed`
- escalate as `implementation_lookup_needed` instead of reading code by default

## Layer and authoring rule

- never create a new script in this skill
- never modify executor implementation in this skill
- if script authoring seems required, hand off to `ccfep-workstream-coder`

## When not to use

- do not use when the main deliverable is a task manifest
- do not use when the user wants direct command execution
- do not use when a single case needs a very narrow summary; use `ccfep-case-state-summary`

## Minimal output schema

```json
{
  "workstream": "",
  "scope": "",
  "status": "",
  "phase": "",
  "evidence": [],
  "missing_evidence": [],
  "next_step": ""
}
```

## Path/file-level expected output

- default inline product: one compact report object
- if materialized locally, write to `E:/ssh_scp/runtime/skills/ccfep/workstream_report/<scope_slug>.json`
- `scope` should resolve to one absolute remote path, one task record path, or one local receipt root
- `evidence` should cite concrete files or paths, prioritizing `E:/ssh_scp/runtime/state/cluster_state.json`, `E:/ssh_scp/runtime/state/cluster_event_log.jsonl`, task records or receipts under `E:/ssh_scp/runtime/state/`, and inspected remote paths under `/lustre/home/users/ewu/...`
- `missing_evidence` should name the missing file, file pattern, or unread path rather than only a prose label
- if the report implies a downstream artifact, name its expected local draft path explicitly

## Ambiguity handling rule

- if status depends on missing evidence, mark `status` as `uncertain`
- keep competing interpretations in `missing_evidence` or a short note
- do not silently upgrade uncertain state to completed state

## Shared discovery rule

Do not maintain a private routing model here.

Reuse protocol-layer discovery for:

- registered vs documented-only workstream state
- path family classification
- capability lookup

If a normalized request object is present, use it as the report scope initializer:

- derive `workstream` and `scope` from `path_resolution` and `resolved_inputs`
- keep report output observational rather than reinterpretive

## Output bias

- current phase
- current status
- evidence basis
- missing evidence
- recommended next step

Keep reports short, structured, and audit-friendly.
