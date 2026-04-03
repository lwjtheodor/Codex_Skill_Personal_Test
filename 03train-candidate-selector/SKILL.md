---
name: 03train-candidate-selector
description: Use when the user wants to pick a subset of 03_train candidates for DFT, apply a candidate-selection policy, or choose the best registered candidates under a budget. Typical requests include "select candidates for the next DFT round", "apply this policy to the candidate list", or "choose a DFT-ready subset from these registered artifacts."
---

# 03train Candidate Selector

Use this skill when candidate artifacts already exist and the task is to choose a final subset, not to register raw artifacts.

## Preferred anchors

- `E:/ssh_scp/workstreams/03_train/agents/candidate_selector/README.md`
- `E:/ssh_scp/workstreams/03_train/contracts/path_families.json`
- `E:/ssh_scp/workstreams/03_train/contracts/execution_map.json`
- candidate registry artifacts under `workstreams/03_train/registry/artifacts`
- selector and policy outputs produced by `ccfep-workstream-input-builder`

## Contract-first boundary

- default to agent README, registry artifacts, normalized request objects, input-builder output, execution maps, downstream policy maps, and task output contracts
- do not inspect Python implementation files unless contract or README evidence is insufficient
- prefer contracts, registry objects, policy objects, and README evidence over executor source
- if resource snapshots or locators are insufficient, emit `resource_lookup_needed`
- escalate as `implementation_lookup_needed` instead of reading code by default

## Layer and authoring rule

- never create a new script in this skill
- never modify executor implementation in this skill
- if script authoring seems required, hand off to `03train-workstream-coder`

## Trigger

- when `candidate_registry` has published candidate artifacts
- when a human requests a new policy pass on existing artifacts

## Preconditions

- candidate registry artifact exists
- selection rule file exists
- `all_features.csv` is available or registered

## Preferred evidence

- normalized request object from `ccfep-request-normalizer` when the request starts from descriptive text
- rule file used
- selection count
- ranking field used
- representative selected rows

## When not to use

- do not use for raw artifact inventory
- do not use for final DFT tree creation
- do not use when policy itself is still undefined

## Minimal output schema

```json
{
  "round_id": "",
  "status": "prepared | completed | partial | blocked | failed | needs_human",
  "selected_count": 0,
  "policy_source": "",
  "next_agent": "dft_campaign_planner | retry_controller | integrator"
}
```

## Normalized request intake

Prefer to read the normalized request object in this order:

1. `workstream`
2. `path_resolution`
3. `markers`
4. `routing`
5. `resolved_inputs`
6. `required_evidence`
7. `failure_state`

### Required fields

- `workstream = "03_train"`
- one candidate root from `path_resolution.normalized_paths` or `resolved_inputs.candidate_root`
- candidate artifacts marker set that includes `all_features.csv` and at least one `candidate_list*.csv` indicator

### Optional fields

- `resolved_inputs.round_id`
- `resolved_inputs.selection_policy`
- `resolved_inputs.selection_budget`
- `routing.preferred_agent`
- `routing.preferred_skill`
- `markers.policy_markers`

### Degrade and fallback

- if workstream identity is missing or not `03_train`, fall back to `ccfep-workstream-protocol`
- if candidate root exists but artifact readiness is unclear, fall back to `ccfep-workstream-report`
- if policy fields are missing, return `needs_human` instead of inventing selection policy
- if `failure_state` is non-empty, stop before candidate selection and return review-style guidance

## Ambiguity handling rule

- if policy options compete, return `needs_human`
- if no candidates satisfy policy, return `blocked`
- if subset is smaller than target but still usable, allow `partial`

## Handoff rule

- default next agent: `dft_campaign_planner`
- if reduced but usable subset exists: still allow downstream handoff
- if no candidates are selected: hand off to `retry_controller`
