---
name: 03train-candidate-registry
description: Use when the user wants to gather, register, or check 03_train candidate files from a model-deviation run, especially under DP_SYS/systems_MLP_MD_*/RUN*. Typical requests include "register these candidates", "check whether all_features.csv and candidate_list files are ready", or "summarize the candidate artifacts for this RUN before selection."
---

# 03train Candidate Registry

Use this skill when the task is about candidate artifact registration, not final selection.

## Preferred anchors

- `E:/ssh_scp/workstreams/03_train/agents/candidate_registry/README.md`
- `E:/ssh_scp/workstreams/03_train/contracts/path_families.json`
- `E:/ssh_scp/workstreams/03_train/contracts/execution_map.json`
- `D:/UsersData/s1365/.codex/skills/ccfep-workstream-input-builder/references/input-object-schema.md`

## Contract-first boundary

- default to agent README, path families, execution maps, normalized request objects, input-builder output, and registry artifacts
- do not inspect Python implementation files unless contract or README evidence is insufficient
- prefer contracts, task output contracts, and agent README over executor source
- if resource snapshots or locators are insufficient, emit `resource_lookup_needed`
- escalate as `implementation_lookup_needed` instead of reading code by default

## Layer and authoring rule

- never create a new script in this skill
- never modify executor implementation in this skill
- if script authoring seems required, hand off to `03train-workstream-coder`

## Trigger

- when `model_devi` completes or partially completes
- when a `DP_SYS/.../RUN*` root needs candidate artifact inventory

## Preconditions

- remote run root exists
- round scope or round id is known or inferable
- stable artifact naming such as `all_features.csv` or `candidate_list*.csv`

## Accepted input

- remote run root
- optional round id
- optional existing receipt or task record

## Preferred evidence

- presence or absence of `all_features.csv`
- representative `candidate_list*.csv` paths
- remote scan exit code
- artifact count

## When not to use

- do not use for final candidate ranking
- do not use when the task is to run model deviation itself
- do not use when the task is to submit DFT jobs from selected candidates

## Minimal output schema

```json
{
  "round_id": "",
  "run_root": "",
  "status": "prepared | completed | partial | blocked | failed | needs_human",
  "artifact_paths": [],
  "next_agent": ""
}
```

## Status classes

- `completed`
- `partial`
- `blocked`
- `failed`
- `prepared`
- `needs_human`

## Handoff rule

- default next agent: `candidate_selector`
- if `all_features.csv` exists but candidate lists are incomplete: `integrator`
- if feature table is missing: `retry_controller`

## Ambiguity handling rule

- if round id is ambiguous, keep the registry status below `completed`
- if artifact naming is inconsistent, prefer `needs_human` over forcing a completed record

## Escalation rule

- if artifact interpretation still depends on implementation-only behavior, stop at `implementation_lookup_needed`
- only inspect executor code when the contract stack and README cannot explain artifact semantics
