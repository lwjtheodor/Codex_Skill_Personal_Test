---
name: ccfep-case-state-summary
description: Use when the user wants a compact status summary for one CCFEP path or case. Typical requests include "what is going on with this path", "summarize this case", "is this RUN complete or still active", or "give me the current state and next step for this remote root."
---

# CCFEP Case State Summary

Use this skill for one case or one path at a time.

## Preferred evidence

- normalized request object from `ccfep-request-normalizer` when the user started with descriptive text
- input-builder output from `ccfep-workstream-input-builder` when the path bundle or completion cues were already stabilized upstream
- `E:/ssh_scp/cluster_control/contracts/workstream_specs.json`
- target `path_families.json`
- target `execution_map.json`
- one target path
- local receipts if present
- one remote listing or one task record if needed

## Contract-first boundary

- default to normalized request objects, input-builder output, workstream specs, path families, execution maps, receipts, and one narrow remote listing
- do not inspect Python implementation files unless contract or README evidence is insufficient
- prefer contracts, task output contracts, and agent README over executor source
- if resource snapshots or locators are insufficient, emit `resource_lookup_needed`
- escalate as `implementation_lookup_needed` instead of reading code by default

## Layer and authoring rule

- never create a new script in this skill
- never modify executor implementation in this skill
- if script authoring seems required, hand off to `ccfep-workstream-coder`

## When not to use

- do not use for multi-case batch routing
- do not use when the main deliverable is a manifest
- do not use for cross-workstream dashboards

## Minimal output schema

```json
{
  "path": "",
  "workstream": "",
  "state": "",
  "evidence": [],
  "missing_evidence": [],
  "next_step": ""
}
```

## Path/file-level expected output

- default inline product: one compact case-state object
- if materialized locally, write to `E:/ssh_scp/runtime/skills/ccfep/case_state_summary/<case_slug>.json`
- `path` must be the absolute remote case or run-root path such as `/lustre/home/users/ewu/...`
- each `evidence` item should name the concrete source path or file, for example `E:/ssh_scp/runtime/state/cluster_state.json`, `E:/ssh_scp/runtime/state/cluster_event_log.jsonl`, one local receipt under `E:/ssh_scp/runtime/state/`, or one inspected remote file under the target root
- each `missing_evidence` item should name the missing file, file pattern, or path family rather than only a prose label
- if the next step is another CCFEP skill, record the expected downstream object class explicitly:
  - `ccfep-workstream-report` -> compact report JSON
  - `ccfep-handoff-planner` -> handoff record JSON
  - `ccfep-workstream-manifest` -> manifest draft JSON

## Ambiguity handling rule

- if evidence conflicts, preserve the conflict explicitly
- if the path cannot be classified cleanly, report `workstream=unknown` until resolved

## Typical inputs

- normalized request object with one resolved target path
- `/lustre/home/users/ewu/cb/<chirality>/<pressure>_<temperature>`
- `/lustre/home/users/ewu/dpmd_work/.../03_train/<subpath>`
- documented `/lustre/home/users/ewu/domain_stat/<subpath>`

## Output shape

- path
- workstream
- state
- evidence seen
- missing evidence
- next recommended step

Keep it compact and directly auditable.

If the upstream input is a normalized request object, summarize the resolved path and evidence state instead of reconstructing markers from scratch.
