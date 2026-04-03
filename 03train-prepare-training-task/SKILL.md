---
name: 03train-prepare-training-task
description: Use when the user wants to prepare a 03_train dataset_run, model workspace, or training folder for the next training step. Typical requests include "prepare this dataset for training", "turn this model workspace into a training task", or "draft the next deepmd_config or deepmd_train handoff."
---

# 03train Prepare Training Task

Use this skill when the question is how to turn dataset or model paths into a training-stage task object.

## Preferred evidence

- normalized request object from `ccfep-request-normalizer` when the user started from descriptive text
- input-builder output from `ccfep-workstream-input-builder`
- `E:/ssh_scp/workstreams/03_train/contracts/path_families.json`
- `E:/ssh_scp/workstreams/03_train/contracts/execution_map.json`
- `E:/ssh_scp/workstreams/03_train/agents/deepmd_config/README.md`
- `E:/ssh_scp/workstreams/03_train/agents/deepmd_train/README.md`
- `dataset_run/RUN*`
- `models_r11/model_*`

## Contract-first boundary

- default to normalized request objects, input-builder output, path families, execution maps, agent README files, task templates, and task output contracts
- do not inspect Python implementation files unless contract or README evidence is insufficient
- prefer contracts, agent README, and manifest-layer templates over executor source
- if resource snapshots or locators are insufficient, emit `resource_lookup_needed`
- escalate as `implementation_lookup_needed` instead of reading code by default

## Layer and authoring rule

- never create a new script in this skill
- never modify executor implementation in this skill
- if script authoring seems required, hand off to `03train-workstream-coder`

## When not to use

- do not use for DFT readiness or ingestion
- do not use for evaluation-only tasks
- do not use for already completed model artifact fetches

## Minimal output schema

```json
{
  "target_path": "",
  "task_type": "prepare_training | submit_training",
  "next_agent": "",
  "required_inputs": [],
  "expected_outputs": []
}
```

## Normalized request intake

Prefer to read the normalized request object in this order:

1. `path_resolution.normalized_paths`
2. `routing`
3. `resolved_inputs`
4. `required_evidence`
5. `failure_state`

### Required fields

- `workstream = "03_train"`
- one usable target from `path_resolution.normalized_paths` or `resolved_inputs.target_path`

### Optional fields

- `path_resolution.path_family`
- `routing.preferred_agent`
- `resolved_inputs.task_type`
- `resolved_inputs.dataset_run`
- `resolved_inputs.model_workspace`
- `expected_outputs`

### Degrade and fallback

- if `workstream` is missing or not `03_train`, fall back to `ccfep-workstream-protocol`
- if target path is missing, fall back to `ccfep-case-state-summary` or `ccfep-workstream-report`
- if path family is missing but target path is present, infer from contracts locally
- if the request object carries `failure_state`, do not draft a training task; return review or inspection guidance

## Ambiguity handling rule

- if the path matches both dataset and model conventions poorly, stop at `inspect_status`
- if `input.json` is absent in a model workspace, do not auto-upgrade to training submission

## Typical handoff

- `dataset_run/RUN*` -> `deepmd_config`
- `models_r11/model_*` -> `deepmd_train`
- trained graph artifacts -> `model_registry`
