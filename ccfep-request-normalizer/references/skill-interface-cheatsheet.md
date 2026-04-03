# Skill Interface Cheatsheet

Use this page as a quick map for how downstream skills consume `normalized_ccfep_request`.

## Standard Read Order

Use this field order unless a skill has stricter local needs:

1. `workstream`
2. `registered_status`
3. `path_resolution`
4. `markers`
5. `routing`
6. `resolved_inputs`
7. `required_evidence`
8. `expected_outputs`
9. `ambiguities`
10. `failure_state`

`expected_outputs` should be treated as a path/file contract, not as a prose wish list. Downstream skills should preserve `root_path`, `file_patterns`, and `consumer` unless they have stronger concrete evidence.

## Fast Routing Chain

Use this default chain:

1. `ccfep-request-normalizer`
2. `ccfep-workstream-protocol` only when workstream/path/capability is still unclear
3. one of:
   - `ccfep-workstream-report`
   - `ccfep-case-state-summary`
   - `ccfep-handoff-planner`
   - `ccfep-workstream-manifest`
   - workstream-local task skill

## Shared Fallback Rule

If `failure_state` is non-empty:

- do not continue as if fully resolved
- prefer `review` or `inspect` style outputs
- call protocol/report layers for clarification before execution-level output

If required fields are missing:

- prefer explicit fallback target over implicit guessing
- keep ambiguity visible in output

## Integrated Skills

### CCFEP layer

| Skill | Required | Optional | Fallback |
|---|---|---|---|
| `ccfep-workstream-protocol` | stable workstream or path hints from normalized object | routing hints, resolved inputs | `unregistered_workstream` / `unknown_path_family` / `no_execution_route` |
| `ccfep-cluster-control` | resolvable target path and command intent | markers, resolved inputs, routing hints | protocol first, then report/review before command execution |
| `ccfep-case-state-summary` | one target path | routing hints, evidence hints | protocol or report if path/workstream unclear |
| `ccfep-workstream-report` | report scope (path or resolved scope) | routing hints, markers, expected outputs | protocol for route clarity, then uncertain report state |
| `ccfep-handoff-planner` | scope + decision context | routing hints, ambiguity notes, required artifacts | review/inspect decision when target is ambiguous |
| `ccfep-event-to-manifest` | trigger basis + target scope | routing hints, resolved input bundle | candidate manifest + review when mapping is uncertain |
| `ccfep-workstream-manifest` | workstream + action scope + target path | resolved inputs, policy markers, invocation hints | protocol/report before manifest finalization |

### Workstream-local layer

| Skill | Required | Optional | Fallback |
|---|---|---|---|
| `03train-prepare-training-task` | `workstream=03_train` and one target path | path family, preferred agent, task hints | protocol or case/report inspection |
| `03train-candidate-selector` | `workstream=03_train`, candidate root, candidate artifacts markers | round id, selection policy/budget, routing hints | protocol/report; `needs_human` if policy missing |
| `cb-dynamics-dos-task` | `workstream=cb` and case root | analysis mode hints, artifact markers | protocol; convergence/report check before execution-ready output |
| `cb-convergence-gate-summary` | `workstream=cb` and case root | round id, artifact hints, convergence scope | protocol or case/report summary; conservative `uncertain` |
| `cb-phase-diagram-batch-task` | `workstream=cb`, batch scope, LI+thermo core pointers | support evidence, pressure policy, packaging hints | protocol/report; `needs_human` on structural conflicts |
| `domain-stat-manifest-draft` | `workstream=domain_stat` or `registered_status=lightweight`, plus branch/probe path | probe type, case scope, preferred skill | protocol; review-ready draft only if semantics incomplete |
| `domain-stat-probe-task` | `workstream=domain_stat` or `registered_status=lightweight`, plus branch root | probe type, case scope, policy markers | protocol or branch summary; preserve lightweight caveat |

## Negative Fixture Expectations

For `underspecified-request.json`:

- expected `failure_state = insufficient_markers`
- expected next action: protocol/review clarification

For `conflicting-request.json`:

- expected `failure_state = conflicting_markers`
- expected next action: review-first disambiguation before routing
