---
name: 03train-md-postprocess-trigger
description: Use when the user wants to turn completed 03_train MD or phase-diagram results into an md_postprocess follow-up task. Typical requests include "trigger postprocess for this MD path", "prepare the next postprocess step from these completed cases", or "turn this finished phase_diagram branch into an md_postprocess manifest."
entry_status: specialized
prefer_router: 03train-simulation-router
---

# 03train MD Postprocess Trigger

Use this skill when completed MD or phase-diagram cases should lead to scientific post-processing.

For general 03_train simulation routing, prefer `03train-simulation-router`.

## Preferred anchors

- `E:/ssh_scp/workstreams/03_train/agents/md_postprocess/README.md`
- `E:/ssh_scp/workstreams/03_train/contracts/path_families.json`
- `E:/ssh_scp/workstreams/03_train/contracts/execution_map.json`
- `D:/UsersData/s1365/.codex/skills/ccfep-workstream-input-builder/references/input-object-schema.md`

## Contract-first boundary

- default to agent README, path families, execution maps, normalized request objects, input-builder output, and task output contracts
- do not inspect Python implementation files unless contract or README evidence is insufficient
- prefer contracts, output contracts, and agent README over executor source
- if resource snapshots or locators are insufficient, emit `resource_lookup_needed`
- escalate as `implementation_lookup_needed` instead of reading code by default

## Layer and authoring rule

- never create a new script in this skill
- never modify executor implementation in this skill
- if script authoring seems required, hand off to `03train-workstream-coder`

## Trigger

- completed `MD/Ver*` case outputs
- completed `phase_diagram_v*` case outputs
- chirality-wide trees with `restart.mlp`

## Preferred evidence

- readable dump path
- completion marker such as `restart.mlp`
- remote batch root or case root

## When not to use

- do not use before trajectory readability is established
- do not use for launching MD itself
- do not use for candidate selection or DFT planning

## Minimal output schema

```json
{
  "trigger_basis": "",
  "remote_root": "",
  "task_type": "md_postprocess_analysis | md_postprocess_batch_analysis",
  "next_object": "manifest | task_record"
}
```

## Ambiguity handling rule

- if only one case is confirmed readable, prefer single-case postprocess
- if a chirality-wide root is known and completion markers are present, prefer batch postprocess
- if dump readability is uncertain, stop before generating a completed postprocess task

## Handoff

- default downstream object: md_postprocess manifest
- default next agent after execution: reviewer
