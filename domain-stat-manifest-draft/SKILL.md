---
name: domain-stat-manifest-draft
description: Use when the user wants a small task draft for domain_stat rather than a full executor-backed workflow. Typical requests include "make a manifest draft for this domain_stat branch", "prepare an inspect or fetch task for this probe", or "turn this domain_stat request into a review-ready task object."
---

# Domain Stat Manifest Draft

Use this skill when a `domain_stat` task should be expressed as a compact manifest-like object.

## Preferred evidence

- normalized request object from `ccfep-request-normalizer` when the user gave descriptive branch intent
- input-builder output from `ccfep-workstream-input-builder`
- `E:/ssh_scp/cluster_control/contracts/workstream_specs.json`
- `E:/ssh_scp/workstreams/domain_stat/contracts/path_families.json`
- documented `domain_stat` path
- probe or case root
- requested operation such as inspect or fetch

## Contract-first boundary

- default to normalized request objects, input-builder output, workstream specs, path families, manifest schema, and documented workflow notes
- do not inspect Python implementation files unless contract or README evidence is insufficient
- prefer contracts and documented workflow notes over executor source
- if resource snapshots or locators are insufficient, emit `resource_lookup_needed`
- escalate as `implementation_lookup_needed` instead of reading code by default

## Layer and authoring rule

- never create a new script in this skill
- never modify executor implementation in this skill
- if script authoring seems required, hand off to `domain-stat-workstream-coder`

## When not to use

- do not use to imply `domain_stat` already has executor parity with `cb` or `03_train`
- do not use when the user only wants a prose summary

## Minimal output schema

```json
{
  "workstream": "domain_stat",
  "task_type": "",
  "action": "",
  "targets": {},
  "assumptions": [
    "domain_stat_is_lightweight_not_executor_complete"
  ]
}
```

## Normalized request intake

Prefer to read the normalized request object in this order:

1. `workstream`
2. `path_resolution`
3. `routing`
4. `resolved_inputs`
5. `ambiguities`
6. `failure_state`

### Required fields

- `workstream = "domain_stat"` or `registered_status = "lightweight"`
- one usable branch or probe path
- one requested operation from `routing`, `markers.intent_markers`, or `resolved_inputs`

### Optional fields

- `path_resolution.path_family`
- `resolved_inputs.probe_type`
- `resolved_inputs.case_scope`
- `routing.preferred_skill`
- `required_evidence`

### Degrade and fallback

- if workstream identity is unclear, fall back to `ccfep-workstream-protocol`
- if path exists but probe details are missing, fall back to `domain-stat-branch-summary` or `domain-stat-probe-task`
- if execution semantics would require first-class executor behavior, stop at review-ready draft
- if `failure_state` is non-empty, preserve the lightweight caveat and return review-ready output only

## Ambiguity handling rule

- if the task would require executor-specific behavior not yet defined, stop at a review-ready draft
- never suppress the lightweight-workstream caveat
