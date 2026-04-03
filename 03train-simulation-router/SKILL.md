---
name: 03train-simulation-router
description: Use when the user wants to prepare, launch, re-run, or monitor a real 03_train simulation task such as DFT or machine-learning-potential MD. Typical requests include "prepare and submit DFT for this candidate set", "deploy the newest model to this MD branch", "check whether this MD branch is ready to run", "start ML-MD sampling for this branch", "re-run this MD case with the DOS dump format", "launch the phase_diagram MD variant for this chirality", or "monitor the current DFT or MD runs."
entry_status: primary
---

# 03train Simulation Router

Use this skill as the main router for real simulation tasks in `03_train`.

This skill is for DFT and ML-potential MD execution, not for generic workflow orchestration or postprocess-only tasks.

## Preferred evidence

- normalized request object from `ccfep-request-normalizer`
- input-builder output from `ccfep-workstream-input-builder`
- `E:/ssh_scp/workstreams/03_train/contracts/path_families.json`
- `E:/ssh_scp/workstreams/03_train/contracts/execution_map.json`
- `D:/UsersData/s1365/.codex/skills/ccfep-io-contracts/references/io-object-family.md`

## Contract-first boundary

- default to normalized request objects, input-builder output, path families, execution maps, task templates, and task output contracts
- do not inspect Python implementation files unless contract or README evidence is insufficient
- if resource snapshots or locators are insufficient, emit `resource_lookup_needed`
- if implementation support is required, emit `implementation_lookup_needed`

## Layer and authoring rule

- never create a new script in this skill
- never modify executor implementation in this skill
- if script authoring seems required, hand off to `03train-workstream-coder`

## Fixed output object

```json
{
  "object_type": "simulation_task",
  "workstream": "03_train",
  "simulation_branch": "dft_execution | md_deployment | md_sampling_launch | simulation_status | simulation_rerun",
  "simulation_mode": "dft | md | phase_diagram_md | dos_dump_variant | msd_racf_variant | rerun | status",
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

- keep DFT and MD as true simulation branches
- keep `sampling_readiness`, `sampling_monitor`, `md_postprocess`, and `model_devi` as internal routing steps or downstream targets, not top-level branches
- use `phase_diagram_md` as a mode under the MD launch branch rather than a separate router

## When not to use

- do not use for candidate selection or DFT planning without actual execution intent
- do not use for postprocess-only requests
- do not use for generic training preparation
