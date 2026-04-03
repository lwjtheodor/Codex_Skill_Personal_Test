# Protocol Output Schema

Use this as the canonical output object for protocol-layer discovery.

```json
{
  "workstream": "",
  "registered_status": "first_class | lightweight | experimental | unregistered",
  "path_family": "",
  "agent_candidates": [],
  "execution_surface": {
    "local_runner": "",
    "remote_scripts": [],
    "remote_commands": []
  },
  "preferred_evidence": [],
  "status_vocabulary": [],
  "handoff_targets": [],
  "output_contract_hints": [],
  "boundary_notes": [],
  "recommended_next_layer": "path_families | execution_map | agent_readme | executor | review",
  "failure_state": ""
}
```

Field notes:

- `registered_status`
  - comes from `workstream_specs.json`
- `path_family`
  - comes from `path_families.json`
- `agent_candidates`
  - comes from `path_families.json`, `execution_map.json`, and README synthesis
- `execution_surface`
  - comes from `execution_map.json`
- `preferred_evidence`
  - should be synthesized from README first, then `required_inputs` and `primary_outputs`
- `status_vocabulary`
  - comes from README
- `handoff_targets`
  - comes from README
- `output_contract_hints`
  - should list downstream artifact roots, receipt roots, or file patterns that later layers should preserve
- `boundary_notes`
  - comes from README
- `recommended_next_layer`
  - should tell the caller whether to keep discovering, stop at review, or hand off to executor
