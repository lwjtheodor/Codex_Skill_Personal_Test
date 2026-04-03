---
name: domain-stat-probe-task
description: Use when the user wants to inspect or prepare work on a domain_stat probe branch such as short_probe or long_probe. Typical requests include "inspect this probe branch", "what does this probe contain", "prepare the next task for this probe", or "summarize the scope and likely outputs for this domain_stat probe."
---

# Domain Stat Probe Task

Use this skill for `domain_stat/<chirality>/<short_probe|long_probe>` style work.

## Preferred anchors

- `E:/ssh_scp/cluster_control/contracts/workstream_specs.json`
- `E:/ssh_scp/workstreams/domain_stat/contracts/path_families.json`
- `E:/ssh_scp/projects/workflow_reviews/domain_stat_workflow.md`
- remote `domain_stat` path listings

## Preferred evidence

- normalized request object from `ccfep-request-normalizer` when the user starts from descriptive probe intent
- chirality root
- probe type
- case directories
- probe outputs or summary tables if present

## Contract-first boundary

- default to normalized request objects, workstream specs, path families, documented workflow notes, and branch listings
- do not inspect Python implementation files unless contract or README evidence is insufficient
- prefer contracts and documented workflow notes over executor source
- if resource snapshots or locators are insufficient, emit `resource_lookup_needed`
- escalate as `implementation_lookup_needed` instead of reading code by default

## Layer and authoring rule

- never create a new script in this skill
- never modify executor implementation in this skill
- if script authoring seems required, hand off to `domain-stat-workstream-coder`

## When not to use

- do not use as if `domain_stat` already had mature executor automation
- do not use for phase-map work under `cb`
- do not use for bulk scheduler submission without a separate manifest

## Minimal output schema

```json
{
  "branch_root": "",
  "probe_type": "short_probe | long_probe | unknown",
  "status": "prepared | inspect_only | manifest_ready | needs_human",
  "case_scope": "",
  "next_step": ""
}
```

## Normalized request intake

Prefer to read the normalized request object in this order:

1. `workstream`
2. `registered_status`
3. `path_resolution`
4. `markers`
5. `routing`
6. `resolved_inputs`
7. `required_evidence`
8. `failure_state`

### Required fields

- `workstream = "domain_stat"` or `registered_status = "lightweight"`
- one probe branch root from `path_resolution.normalized_paths` or `resolved_inputs.branch_root`

### Optional fields

- `resolved_inputs.probe_type`
- `resolved_inputs.case_scope`
- `markers.policy_markers`
- `routing.preferred_skill`
- `expected_outputs`

### Degrade and fallback

- if workstream identity is unclear, fall back to `ccfep-workstream-protocol`
- if branch root is missing, fall back to `domain-stat-branch-summary`
- if probe type is missing, keep `unknown` and continue with inspect-only or review-ready output
- if execution semantics require first-class automation, stop at review-ready output and preserve lightweight caveat
- if `failure_state` is non-empty, avoid manifest-ready claims

## Ambiguity handling rule

- if probe type cannot be inferred, use `unknown`
- always preserve the lightweight-workstream caveat

## Handoff rule

- default downstream object: branch summary or manifest draft
- if execution semantics are missing: stop at review-ready output
