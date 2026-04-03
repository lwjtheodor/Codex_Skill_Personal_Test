---
name: cb-production-analysis-router
description: Use when the user wants to run or prepare cb second-stage analysis based on simulation outputs, especially LI, frac_solid, thermo-style production analysis, readiness checks, or phase-diagram handoff. Typical requests include "run updated LI analysis for this case", "prepare frac_solid analysis from existing outputs", "check whether this case is ready for LI or thermo production analysis", "prepare production batch handoff for phase diagram generation", or "check whether the new LI run is ready for phase diagram packaging."
entry_status: primary
---

# CB Production Analysis Router

Use this skill as the main router for `cb` second-stage analysis and production-analysis handoff.

This skill is for analysis built on simulation outputs, not for launching MSD, RACF, DOS, or fill-in simulation branches.

## Preferred evidence

- normalized request object from `ccfep-request-normalizer`
- input-builder output from `ccfep-workstream-input-builder`
- `E:/ssh_scp/workstreams/cb/contracts/path_families.json`
- `E:/ssh_scp/workstreams/cb/contracts/execution_map.json`
- task output contract and downstream policy map

## Contract-first boundary

- default to normalized request objects, input-builder output, path families, execution maps, task output contracts, and task templates
- do not inspect Python implementation files unless contract or README evidence is insufficient
- if resource snapshots or locators are insufficient, emit `resource_lookup_needed`
- if implementation support is required, emit `implementation_lookup_needed`

## Layer and authoring rule

- never create a new script in this skill
- never modify executor implementation in this skill
- if script authoring seems required, hand off to `cb-workstream-coder`

## Fixed output object

```json
{
  "object_type": "secondary_analysis_task",
  "workstream": "cb",
  "analysis_branch": "li_phase_map | thermo_fit | production_readiness_check | phase_diagram_batch_handoff",
  "analysis_mode": "li | frac_solid | thermo | readiness | batch_handoff",
  "operation_mode": "inspect | prepare_manifest | run | rerun | summarize | handoff",
  "input_artifact_roots": [],
  "derived_result_inputs": [],
  "executor_target": "",
  "expected_outputs": [],
  "downstream_handoff_target": "",
  "failure_state": ""
}
```

## Branch rule

- keep `coexistence_resolver` as an optional downstream handoff target, not a top-level branch
- keep LI and frac_solid inside the `li_phase_map` family
- use `phase_diagram_batch_handoff` only for readiness and package handoff, not final batch execution itself

## When not to use

- do not use for MSD, RACF, DOS, or fill-in simulation launch
- do not use for general lifecycle or convergence checks
