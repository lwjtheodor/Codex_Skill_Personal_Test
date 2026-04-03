# Request Object Schema

Use this reference when emitting the normalized request object for downstream CCFEP consumers.

## Purpose

The object is meant to preserve intent, markers, and resolved machine inputs in one place so the next skill, agent, or executor does not need to reinterpret the user's wording.

Canonical template:

- [canonical-request-template.json](./canonical-request-template.json)

Example fixtures:

- [fixtures-index.md](./fixtures-index.md)

Cross-skill intake cheatsheet:

- [skill-interface-cheatsheet.md](./skill-interface-cheatsheet.md)

## Schema

```json
{
  "request_type": "normalized_ccfep_request",
  "source_text": "",
  "workstream": "",
  "registered_status": "first_class | lightweight | experimental | unregistered",
  "path_resolution": {
    "input_paths": [],
    "normalized_paths": [],
    "path_family": "",
    "path_family_confidence": 0.0
  },
  "markers": {
    "path_markers": [],
    "intent_markers": [],
    "artifact_markers": [],
    "policy_markers": []
  },
  "routing": {
    "capability_group": "",
    "preferred_agent": "",
    "preferred_skill": "",
    "preferred_executor": "",
    "handoff_mode": "skill | agent | executor | review"
  },
  "resolved_inputs": {},
  "required_evidence": [],
  "expected_outputs": [
    {
      "kind": "draft | manifest | report | handoff | remote_artifact",
      "root_path": "",
      "file_patterns": [],
      "consumer": ""
    }
  ],
  "ambiguities": [],
  "failure_state": "",
  "next_step_hint": ""
}
```

## Construction Notes

- `input_paths`
  - preserve user-supplied path fragments before normalization
- `normalized_paths`
  - use the canonical remote path form when it can be inferred safely
- `path_family_confidence`
  - use a numeric score when more than one family is plausible
- `capability_group`
  - prefer execution-map capability wording over ad hoc prose
- `preferred_skill`
  - use only if a skill is the best next consumer
- `preferred_executor`
  - use only if the request is already specific enough for executor-level handoff
- `resolved_inputs`
  - include rule-built inputs such as round ids, chirality lists, artifact roots, dump conventions, or policy bundles
- `required_evidence`
  - include missing files, manifests, receipts, or confirmations needed for safe continuation
- `expected_outputs`
  - keep these as downstream-facing path/file descriptors, not long explanations
  - every entry should include a concrete `root_path`, one or more `file_patterns`, and the downstream `consumer`
- `ambiguities`
  - include every unresolved branch choice that could change downstream behavior
- `failure_state`
  - use an explicit machine-friendly value rather than prose

## Consumer Rule

Downstream skills should read this object in the following order:

1. `workstream`
2. `path_resolution`
3. `routing`
4. `resolved_inputs`
5. `required_evidence`
6. `ambiguities`
7. `failure_state`

If `failure_state` is non-empty, downstream consumers should not silently continue as if the object were fully resolved.

## Example

```json
{
  "request_type": "normalized_ccfep_request",
  "source_text": "Prepare the candidates under DP_SYS/systems_MLP_MD_10_5/RUN12 for the next DFT step.",
  "workstream": "03_train",
  "registered_status": "first_class",
  "path_resolution": {
    "input_paths": [
      "DP_SYS/systems_MLP_MD_10_5/RUN12"
    ],
    "normalized_paths": [
      "/lustre/home/users/ewu/dpmd_work/Gen1_short_range_r2SCAN_D4_700/03_train/DP_SYS/systems_MLP_MD_10_5/RUN12"
    ],
    "path_family": "dp_sys",
    "path_family_confidence": 0.98
  },
  "markers": {
    "path_markers": [
      "DP_SYS/systems_MLP_MD_10_5/RUN12"
    ],
    "intent_markers": [
      "prepare",
      "route"
    ],
    "artifact_markers": [
      "all_features.csv",
      "candidate_list*.csv"
    ],
    "policy_markers": [
      "next_dft"
    ]
  },
  "routing": {
    "capability_group": "candidate_to_dft_handoff",
    "preferred_agent": "candidate_selector",
    "preferred_skill": "03train-candidate-selector",
    "preferred_executor": "",
    "handoff_mode": "skill"
  },
  "resolved_inputs": {
    "round_id": "RUN12",
    "chirality": "10_5",
    "candidate_root": "/lustre/home/users/ewu/dpmd_work/Gen1_short_range_r2SCAN_D4_700/03_train/DP_SYS/systems_MLP_MD_10_5/RUN12",
    "required_candidate_artifacts": [
      "all_features.csv",
      "candidate_list*.csv"
    ]
  },
  "required_evidence": [],
  "expected_outputs": [
    {
      "kind": "draft",
      "root_path": "/lustre/home/users/ewu/dpmd_work/Gen1_short_range_r2SCAN_D4_700/03_train/DP_SYS/systems_MLP_MD_10_5/RUN12",
      "file_patterns": [
        "all_features.csv",
        "candidate_list*.csv"
      ],
      "consumer": "03train-candidate-selector"
    },
    {
      "kind": "handoff",
      "root_path": "E:/ssh_scp/runtime/skills/ccfep/request_normalizer/",
      "file_patterns": [
        "request_run12.json"
      ],
      "consumer": "03train-candidate-selector"
    }
  ],
  "ambiguities": [],
  "failure_state": "",
  "next_step_hint": "handoff_to_skill"
}
```
