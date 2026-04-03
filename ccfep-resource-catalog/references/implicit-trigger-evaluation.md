# Implicit Trigger Evaluation

## Routing map

### CB simulation requests

Primary router:

- `cb-simulation-router`

Specialized entry:

- `cb-dynamics-dos-task`

### CB secondary analysis requests

Primary router:

- `cb-production-analysis-router`

Specialized entry:

- `cb-phase-diagram-batch-task`

### 03_train true simulation requests

Primary router:

- `03train-simulation-router`

Specialized post-simulation entry:

- `03train-md-postprocess-trigger`

## Scenario A

Hypothetical user request:

> Run the new LI analysis under the remote cb folder on CCFEP. The LI script has already been updated locally, but the remote copy is still old. Sync the updated analysis script to the remote side and start the analysis task.

Expected implicit skill path:

1. `ccfep-request-normalizer`
2. `cb-production-analysis-router`
3. `ccfep-cluster-control`
4. `ccfep-workstream-manifest`

Verdict:

- `cb-production-analysis-router` should now be the main workstream-local match
- `cb-simulation-router` should not absorb this request
- `cb-workstream-coder` should not trigger if only sync-and-submit is needed

## Scenario B

Hypothetical user request:

> Run DOS on these converged cb cases, and if the local DOS script changed, sync it first and then submit the remote analysis.

Expected implicit skill path:

1. `ccfep-request-normalizer`
2. `cb-simulation-router`
3. `ccfep-cluster-control`
4. `ccfep-workstream-manifest`

Verdict:

- `cb-simulation-router` should be the main workstream-local match
- `cb-production-analysis-router` should not absorb this request
- `cb-dynamics-dos-task` remains a specialized fallback, not the primary router

## Scenario C

Hypothetical user request:

> Prepare and submit DFT for this candidate set, then monitor whether the remote DFT jobs are still running.

Expected implicit skill path:

1. `ccfep-request-normalizer`
2. `03train-simulation-router`
3. `ccfep-cluster-control`
4. `ccfep-workstream-manifest`

Verdict:

- `03train-simulation-router` should handle true simulation routing
- candidate-selection and postprocess skills should not absorb this request

## Counterexamples

- `check this case`
  - should go to `cb-case-lifecycle-summary`
- `is this case converged`
  - should go to `cb-convergence-gate-summary`
- `prepare final phase diagram batch`
  - should go to `cb-phase-diagram-batch-task` or be explicitly handed off there by `cb-production-analysis-router`
- `prepare postprocess for the completed MD run`
  - should not be treated as a true simulation request
  - should hand off to `03train-md-postprocess-trigger`
- `modify the DOS script`
  - should go to `cb-workstream-coder`
- `modify the shared sync wrapper`
  - should go to `ccfep-workstream-coder`

## Conclusion

- `cb` now has separate main routers for simulation tasks and second-stage analysis tasks
- `03_train` now has a dedicated main router for true simulation tasks
- specialized skills remain available but are no longer the preferred general entrypoints
