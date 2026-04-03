---
name: ccfep-workstream-protocol
description: Use when the main question is "what kind of workstream thing is this" or "how should the skill system interpret this path or branch." Typical requests include "which workstream does this belong to", "how should this path be classified", or "what layer should handle this target next."
---

# CCFEP Workstream Protocol

Use this skill when extending the system or when deciding how a new workstream should be wired into the skill layer.

## Core restraint

This skill is for discovery, compatibility interpretation, and graceful failure.

It should:

- discover registered workstreams
- classify paths through contracts
- identify capability groups and current implementations
- interpret agent boundaries
- recommend downstream paths

It should not:

- act as a universal executor
- replace workstream-local skills
- become a second hardcoded control plane

## Preferred evidence

- normalized request object from `ccfep-request-normalizer` when the request started from free-form text
- `E:/ssh_scp/cluster_control/contracts/workstream_specs.json`
- target workstream `contracts/path_families.json`
- target workstream `contracts/execution_map.json`
- target agent README
- manifest schema or task templates when the downstream object shape matters
- `references/protocol-output-schema.md`

## Contract-first boundary

Treat this skill as a contract-layer interpreter.

- default to `workstream_specs.json`, `path_families.json`, `execution_map.json`, agent README, manifest schema, task templates, and the normalized request object
- do not inspect Python implementation files unless contract or README evidence is insufficient
- prefer specs, path families, execution maps, and agent README over executor source
- if resource snapshots or locators are insufficient, emit `resource_lookup_needed`
- escalate as `implementation_lookup_needed` instead of reading code by default

## Layer and authoring rule

- resource layer answers where contracts, snapshots, and freshness checks live
- shared object layer answers what protocol-discovery or downstream objects should look like
- never create a new script in this skill
- never modify executor implementation in this skill
- if script authoring seems required, hand off to `ccfep-workstream-coder`

## Discovery order

1. consume the normalized request object when available instead of re-parsing the user's wording
2. discover the workstream from `workstream_specs.json`
3. classify paths through `path_families.json`
4. discover executors and remote contracts through `execution_map.json`
5. discover workstream semantics through agent README files
6. inspect implementation only after returning `implementation_lookup_needed` or when the user explicitly requests implementation-level checking

## Failure semantics

Each discovery stage should fail explicitly:

- `workstream_specs.json` has no matching workstream
  - `unregistered_workstream`
- `path_families.json` cannot classify the target
  - `unknown_path_family`
- `execution_map.json` has no matching capability route
  - `no_execution_route`
- agent README is missing or too incomplete to define the boundary
  - `boundary_unknown`
- implementation details are required but contract-layer evidence is not enough
  - `implementation_lookup_needed`
- executor or implementation entrypoint is missing after implementation lookup is justified
  - `implementation_missing`

Prefer explicit failure states over silent fallback.

## When not to use

- do not use for single concrete task execution
- do not use when the target workstream is already known and no protocol decision is needed
- do not use as a replacement for domain-specific skills

## Fixed output object

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

## Path/file-level expected output

- default inline product: one protocol-discovery object
- if materialized locally, write to `E:/ssh_scp/runtime/skills/ccfep/workstream_protocol/<scope_slug>.json`
- `execution_surface.local_runner` must be a concrete local file path when known
- `execution_surface.remote_scripts` and `execution_surface.remote_commands` should preserve absolute paths or path-bearing command forms when known
- `preferred_evidence` should include concrete contract or README paths first
- `output_contract_hints` should list expected downstream artifact roots or file patterns that consumers should carry into manifests, reports, and output contracts
- `handoff_targets` should name downstream layers together with the object they are expected to emit

This output shape should be treated as fixed for protocol consumers.

Top-level skills should consume this object first instead of performing private rediscovery.

If a normalized request object already provides stable path markers or routing hints, treat protocol as the contract verifier and capability expander, not as a second natural-language interpreter.

## Ambiguity handling rule

- if a branch is not in `workstream_specs.json`, treat it as documented-only until promoted
- do not silently hardcode a new workstream into control-layer skills
- prefer adding one new spec entry plus local contracts over patching multiple skills by name
- if the workstream is registered but executor implementation is absent, return the fixed object with `failure_state = "implementation_missing"` and `recommended_next_layer = "review"`

## Contract layering rule

Keep each layer narrow:

- `workstream_specs.json`
  - identity
  - registration status
  - stable root contracts
  - pointers to lower-level contracts
- `path_families.json`
  - path classification
  - workflow family detection
- `execution_map.json`
  - capability groups
  - current implementations
- agent README
  - semantic boundary
- executor
  - actual implementation

Do not let `workstream_specs.json` become a dump for workflow-specific procedural rules.

## Capability-first rule

Prefer capability mapping over executor-name coupling.

Good pattern:

- path family -> capability group
- capability group -> current implementation

Less stable pattern:

- path family -> executor filename only

## Agent README schema bias

Encourage each agent README to stabilize around:

- role or scope
- trigger
- inputs
- outputs
- status classes
- handoff rule
- boundary
- expected path/file outputs

## Extensibility rule

For future workstreams, prefer this contract stack:

- `workstream_specs.json`
- `path_families.json`
- `execution_map.json`
- agent README
- executor

Skills should consume this stack instead of baking branch rules directly into prompt text.
