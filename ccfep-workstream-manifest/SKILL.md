---
name: ccfep-workstream-manifest
description: Use when the user wants a concrete CCFEP task record for remote work. Typical requests include "draft the manifest for this task", "prepare the audit-friendly execution record", "turn this request into a runnable manifest", "make the next remote task object for cb, 03_train, or domain_stat", "prepare the upload and submit task for this analysis", or "turn this script-sync plus remote-run request into one execution record."
---

# CCFEP Workstream Manifest

Use this skill when the main deliverable is a compact manifest rather than raw cluster control.

## Workspace anchors

Prefer these files in the current workspace:

- `E:/ssh_scp/docs/ccfep_cluster_control_reuse.json`
- `E:/ssh_scp/docs/CCFEP_SHORT_MANUAL.md`
- `E:/ssh_scp/cluster_control/contracts/workstream_specs.json`
- `E:/ssh_scp/workstreams/*/contracts/path_families.json`
- `E:/ssh_scp/workstreams/cb/contracts/execution_map.json`
- `E:/ssh_scp/workstreams/03_train/contracts/execution_map.json`
- `D:/UsersData/s1365/.codex/skills/ccfep-request-normalizer/references/request-object-schema.md`
- `D:/UsersData/s1365/.codex/skills/ccfep-workstream-input-builder/references/input-object-schema.md`

Load references only as needed:

- `references/manifest-schema.md`
- `references/task-templates.md`

## Contract-first boundary

- treat this skill as a manifest-layer consumer of contract objects, not executor code
- default to the normalized request object, workstream specs, path families, execution maps, agent README, manifest schema, task templates, task output contract, and input-builder output
- do not inspect Python implementation files unless contract or README evidence is insufficient
- prefer specs, path families, execution maps, task templates, task output contracts, and agent README over executor source
- if resource snapshots or locators are insufficient, emit `resource_lookup_needed`
- escalate as `implementation_lookup_needed` instead of reading code by default

## Layer and authoring rule

- never create a new script in this skill
- never modify executor implementation in this skill
- if script authoring seems required, hand off to `ccfep-workstream-coder`

## Output contract

Default manifest shape:

```json
{
  "manifest_version": "2",
  "cluster": "ccfep",
  "workstream": "",
  "task_type": "",
  "action": "",
  "targets": {},
  "parameters": {},
  "inputs": {},
  "expected_outputs": {
    "artifacts": {
      "primary": [
        {
          "root_path": "",
          "files": [],
          "file_patterns": []
        }
      ]
    },
    "state_updates": {
      "local_receipts": [
        {
          "root_path": "E:/ssh_scp/runtime/state",
          "file_patterns": []
        }
      ]
    },
    "constraints": {}
  },
  "executor": {
    "executor_family": "",
    "executor_name": "",
    "mode": "",
    "entrypoint": "",
    "invocation": {
      "type": "cli | template",
      "command": "",
      "argv": []
    },
    "invocation_variants": []
  },
  "precheck": [],
  "assumptions": [],
  "risk_level": "",
  "approval_reason": "",
  "trigger_basis": ""
}
```

## Path/file-level expected output

- default inline product: one manifest draft
- if materialized locally, write to `E:/ssh_scp/runtime/skills/ccfep/workstream_manifest/<task_slug>.manifest.json`
- `targets` and `inputs` must preserve absolute remote or local paths only
- every `expected_outputs.artifacts` entry must carry a `root_path` plus either explicit `files` or `file_patterns`
- every `expected_outputs.state_updates.local_receipts` entry should point to `E:/ssh_scp/runtime/state/` unless a different local state root is explicitly justified
- if the manifest stages another local file, include that path under `inputs` or `expected_outputs`, not only in prose

## Default procedure

1. If the request started as free-form text, first consume the normalized request object from `ccfep-request-normalizer`.
2. Normalize the target path to absolute `/lustre/home/users/ewu/...` form.
3. Classify into `cb`, `03_train`, or documented-only `domain_stat`.
4. Choose the smallest matching task template.
5. Keep `action` as a short stable action id, not a sentence with parameters.
6. Put variable execution policy into `parameters`, not `action`.
7. Keep `inputs` resource-oriented; if an input is expanded from parameters, name it `resolved_*` or `expanded_*`.
8. Carry request-normalizer `resolved_inputs` into `inputs` or `parameters` instead of rebuilding them privately.
9. Split `expected_outputs` into `artifacts`, `state_updates`, and `constraints` when applicable.
10. Keep `executor` machine-oriented.
11. When one executor supports multiple CLI forms, encode them in `executor.invocation_variants`.
12. Make `precheck` a list of structured check objects.
13. Put unresolved interpretation into `assumptions`, not `precheck`.

## Routing rules

- `cb`
  - use for `/lustre/home/users/ewu/cb/...`
  - typical task types: `submit_case`, `inspect_case`, `fetch_analysis`, `route_analysis`
- `03_train`
  - use for `/lustre/home/users/ewu/dpmd_work/Gen1_short_range_r2SCAN_D4_700/03_train/...`
  - typical task types: `inspect_status`, `validate_dft`, `prepare_training`, `inspect_eval`, `fetch_results`
- `domain_stat`
  - use only as a documented branch label for `/lustre/home/users/ewu/domain_stat/...`
  - always keep the non-first-class caveat explicit in `precheck` or nearby text

## When to switch skills

- if the user starts with a descriptive request that still needs marker extraction, first use `ccfep-request-normalizer`
- if the user wants to actually run commands or inspect cluster state live, also use `ccfep-cluster-control`
- if the user only wants the execution record or task handoff object, stay in this skill

## Token discipline

- prefer a filled template over a long explanation
- do not restate cluster facts already encoded in the JSON
- do not expand unrelated workflow background
