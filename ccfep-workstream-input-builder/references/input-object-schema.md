# Input Object Schema

Use this reference when emitting a contract-first input object for downstream CCFEP skills.

## Schema

```json
{
  "object_type": "ccfep_workstream_input",
  "request_ref": "",
  "workstream": "cb | 03_train | domain_stat",
  "path_family": "",
  "scope_roots": [],
  "selector_outputs": [
    {
      "kind": "case_selector | run_selector | artifact_selector | policy_selector",
      "source": "",
      "paths": [],
      "files": [],
      "file_patterns": []
    }
  ],
  "policy_bundle": {},
  "resolved_inputs": {},
  "expected_artifacts": [
    {
      "root_path": "",
      "files": [],
      "file_patterns": [],
      "consumer": ""
    }
  ],
  "completion_cues": [],
  "downstream_consumers": [],
  "required_evidence": [],
  "assumptions": [],
  "failure_state": ""
}
```

## Construction notes

- `request_ref`
  - reference the normalized request object or upstream contract object that this input object extends
- `scope_roots`
  - preserve absolute paths only
- `selector_outputs`
  - reference the narrowest concrete selection artifact available
- `policy_bundle`
  - store budget, case filters, dispatch rules, fetch policy, or completion policy in machine-usable form
- `resolved_inputs`
  - include the exact fields downstream consumers should read instead of rediscovering inputs
- `expected_artifacts`
  - describe likely remote or local artifact roots without claiming they already exist
- `completion_cues`
  - name auditable markers that a watcher or output-contract skill can test later
- `failure_state`
  - use `implementation_lookup_needed` when contract-layer evidence is not enough

## Consumer rule

Downstream skills should read this object in the following order:

1. `workstream`
2. `path_family`
3. `scope_roots`
4. `selector_outputs`
5. `policy_bundle`
6. `resolved_inputs`
7. `expected_artifacts`
8. `completion_cues`
9. `required_evidence`
10. `failure_state`
