---
name: ccfep-workstream-input-builder
description: Use when the user intent is already roughly known, but downstream skills still need a precise input bundle. Typical requests include "build the exact inputs for this manifest", "turn these markers into a concrete selection object", or "prepare the resolved inputs for the next CCFEP step."
---

# CCFEP Workstream Input Builder

Use this skill to turn marker-led or path-led requests into a fixed input object that downstream skills can consume without rebuilding selectors, path expansion, or output guesses.

This skill sits between request normalization and downstream task drafting.

It should describe:

- resolved scope roots
- selector outputs
- policy bundles
- expected artifact roots
- completion cues
- downstream-ready input fields

It should not:

- execute cluster commands
- replace manifest drafting
- replace current-state reporting
- inspect Python implementation files by default

## Preferred evidence

- normalized request object from `ccfep-request-normalizer`
- `E:/ssh_scp/cluster_control/contracts/workstream_specs.json`
- target workstream `contracts/path_families.json`
- target workstream `contracts/execution_map.json`
- capability registry
- downstream policy map
- task output contract
- agent README
- selector or input-builder outputs already materialized upstream
- manifest schema and task templates when a downstream draft shape matters
- `references/input-object-schema.md`
- `references/downstream-contract-objects.md`

## Contract-first boundary

- default to workstream specs, path families, execution maps, capability registry, downstream policy map, task output contract, agent README, manifest schema, task templates, and the normalized request object
- do not inspect Python implementation files unless contract or README evidence is insufficient
- prefer specs, path families, execution maps, selector outputs, and agent README over executor source
- if resource snapshots or locators are insufficient, emit `resource_lookup_needed`
- escalate as `implementation_lookup_needed` instead of reading code by default

## Layer and authoring rule

- resource layer answers where to find snapshots, templates, and freshness signals
- shared object layer answers what `ccfep_workstream_input`, `policy_bundle_object`, or `selector_output_object` should look like
- never create a new script in this skill
- never modify executor implementation in this skill
- if script authoring seems required, hand off to `ccfep-workstream-coder`

## When to use

- when the hard part is resolving exact `inputs` or `resolved_inputs`
- when marker extraction already happened but selector or path expansion still needs to be stabilized
- when manifests, reports, watchers, or handoff planners would otherwise have to rediscover case roots, file patterns, or completion cues

## When not to use

- do not use when the normalized request object is already sufficient for the next skill
- do not use when the user explicitly wants implementation-level behavior checking
- do not use as a substitute for `ccfep-workstream-protocol` when workstream registration is still unclear

## Fixed output object

Use the schema in [input-object-schema.md](./references/input-object-schema.md).

Default output shape:

```json
{
  "object_type": "ccfep_workstream_input",
  "request_ref": "",
  "workstream": "",
  "path_family": "",
  "scope_roots": [],
  "selector_outputs": [],
  "policy_bundle": {},
  "resolved_inputs": {},
  "expected_artifacts": [],
  "completion_cues": [],
  "downstream_consumers": [],
  "required_evidence": [],
  "assumptions": [],
  "failure_state": ""
}
```

## Build order

1. consume the normalized request object
2. confirm workstream identity from `workstream_specs.json`
3. resolve path family and stable scope roots through `path_families.json`
4. map capability and consumer surfaces through `execution_map.json`
5. load capability registry, downstream policy map, task output contract, or selector outputs when available
6. emit one fixed input object for the narrowest downstream consumer
7. if exact inputs still depend on missing snapshots or locators, return `resource_lookup_needed`
8. if exact inputs still depend on implementation-only knowledge, return `implementation_lookup_needed`

## Path/file-level expected output

- default inline product: one input-builder object
- if materialized locally, write to `E:/ssh_scp/runtime/skills/ccfep/workstream_input_builder/<scope_slug>.json`
- `scope_roots` must preserve absolute remote or local roots only
- `selector_outputs` should reference concrete files or object ids, not prose summaries
- `resolved_inputs` should contain the exact downstream fields that a manifest, report, watcher, or local skill should consume
- `expected_artifacts` should carry concrete `root_path` plus explicit `files` or `file_patterns`
- `completion_cues` should be operational markers that can feed `ccfep-task-output-contract` or `ccfep-completion-watcher`

## Shared object rule

Use this skill to centralize items that were previously rediscovered ad hoc:

- marker-to-path resolution
- case or run selection
- output prediction inputs
- completion-cue bundles
- downstream policy application

Downstream skills should consume this object first instead of rebuilding private selector logic.

## Ambiguity handling rule

- if multiple selectors compete, keep them explicit in `selector_outputs` or `assumptions`
- if required evidence is missing, emit a partial object plus concrete `required_evidence`
- if implementation-only behavior is required, return `implementation_lookup_needed` instead of reading code by default
