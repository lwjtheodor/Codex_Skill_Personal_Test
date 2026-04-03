# Shared Object Family

## Resource layer objects

- `resource_catalog`
- `resource_locator_result`
- `resource_freshness_report`

## Shared object layer objects

- `normalized_ccfep_request`
- `ccfep_workstream_input`
- `task_output_contract`
- `simulation_task`
- `secondary_analysis_task`
- `policy_bundle_object`
- `selector_output_object`
- `template_registry_index`
- `template_resolution_result`

## Rule

Resource objects say where a thing is and whether it is fresh.
Shared objects say what the thing should look like after it is found.

## Simulation and analysis split

- `simulation_task`
  - use for true remote simulation execution, launch, rerun, monitoring, or sync-and-submit tasks
- `secondary_analysis_task`
  - use for second-stage analysis built from existing simulation outputs
