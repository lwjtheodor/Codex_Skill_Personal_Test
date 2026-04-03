---
name: cb-simulation-router
description: Use when the user wants to run, re-run, monitor, or prepare a cb remote simulation branch such as MSD, RACF, DOS, or missing press_temp fill-in work. Typical requests include "run MSD for this cb case", "start RACF analysis for these cases", "run DOS on these converged cases", "fill in missing press_temp points for this branch", "sync local simulation script updates and submit remote runs", "re-run the failed cb analysis cases", or "check whether these remote simulation branches are still running."
entry_status: primary
---

# CB Simulation Router

Use this skill as the main router for `cb` remote simulation-branch work.

This skill is for simulation tasks, not second-stage LI or frac_solid analysis.

## Preferred evidence

- normalized request object from `ccfep-request-normalizer`
- input-builder output from `ccfep-workstream-input-builder`
- `E:/ssh_scp/workstreams/cb/contracts/path_families.json`
- `E:/ssh_scp/workstreams/cb/contracts/execution_map.json`
- `E:/ssh_scp/workstreams/cb/agents/dynamics_dos/README.md`
- local or remote script sync context when the request includes updated scripts

## Contract-first boundary

- default to normalized request objects, input-builder output, path families, execution maps, task templates, and task output contracts
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
  "object_type": "simulation_task",
  "workstream": "cb",
  "simulation_branch": "dynamics_branch | press_temp_fillin | simulation_rerun | simulation_status",
  "simulation_mode": "msd | racf | dos | mixed | fillin | rerun | status",
  "operation_mode": "inspect | prepare_manifest | sync_and_submit | launch | rerun | monitor | summarize | handoff",
  "script_sync_needed": false,
  "executor_target": "",
  "required_inputs": [],
  "expected_outputs": [],
  "downstream_handoff_target": "",
  "failure_state": ""
}
```

## Branch rule

- keep `msd`, `racf`, and `dos` as modes under `dynamics_branch`
- keep missing `press_temp` fill-in as `press_temp_fillin`
- keep status-only and rerun requests separate from fresh launch requests

## When not to use

- do not use for LI, frac_solid, or thermo second-stage analysis
- do not use for final phase-diagram batch packaging
- do not use for general case lifecycle summaries
