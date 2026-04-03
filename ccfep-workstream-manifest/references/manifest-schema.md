# Manifest Schema

Use this when drafting or validating a compact CCFEP task manifest.

## Canonical fields

```json
{
  "manifest_version": "2",
  "cluster": "ccfep",
  "workstream": "cb | 03_train | domain_stat",
  "task_type": "short_stable_label",
  "action": "short_stable_action_id",
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
  "precheck": [
    {
      "op": "path_exists",
      "path": "/lustre/home/users/ewu/..."
    }
  ],
  "assumptions": ["explicit interpretation recorded separately from precheck"],
  "risk_level": "low | medium | high",
  "approval_reason": "why this task should enter the audit queue",
  "trigger_basis": "upstream event, request, or state basis"
}
```

## Field rules

- `cluster`
  - fixed to `ccfep`
- `workstream`
  - `cb` and `03_train` are first-class
  - `domain_stat` is documented but not first-class
- `task_type`
  - keep stable and short
- `action`
  - short stable action name only
- `targets`
  - primary resource locations
- `parameters`
  - machine-usable policy knobs and counts
- `inputs`
  - concrete resources, file names, path lists, selectors, or manifests
  - if derived from parameters, mark as `resolved_*` or `expanded_*`
- `expected_outputs`
  - split into:
    - `artifacts`
    - `state_updates`
    - `constraints`
  - every artifact entry should include a concrete `root_path` plus either `files` or `file_patterns`
  - every local state update should anchor receipt expectations to a concrete local path such as `E:/ssh_scp/runtime/state`
- `executor`
  - use structured fields such as family, name, mode, entrypoint, invocation
  - when one script supports multiple CLI forms, add `invocation_variants`
- `precheck`
  - only validations that can pass or fail operationally
  - prefer structured objects over string DSL
- `assumptions`
  - interpretations, ambiguity resolutions, default policies
- `risk_level`
  - short audit label
- `approval_reason`
  - short justification for audit routing
- `trigger_basis`
  - request or upstream-state basis for creation
