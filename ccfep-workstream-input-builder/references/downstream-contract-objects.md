# Downstream Contract Objects

Use these contract objects to avoid implementation lookup when building downstream-ready inputs.

## Preferred objects

- `workstream_specs.json`
  - stable workstream identity and registration status
- `path_families.json`
  - branch and path classification
- `execution_map.json`
  - capability-to-consumer routing
- capability registry
  - stable capability names, accepted inputs, and expected outputs
- downstream policy map
  - selection budgets, completion thresholds, or fetch policy that should not be inferred from code
- task output contract
  - expected artifacts, receipts, completion criteria, and default next action
- selector outputs
  - concrete case, run, or artifact selections that should be reused downstream
- manifest schema and task templates
  - exact object shapes for downstream drafting

## Escalation rule

If these objects do not explain how to build the required input bundle, return `implementation_lookup_needed` instead of reading executor code by default.
