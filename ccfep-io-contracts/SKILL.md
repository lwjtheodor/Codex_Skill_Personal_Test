---
name: ccfep-io-contracts
description: Use when the task is about the standard shapes of shared CCFEP objects rather than a specific workflow action. Typical requests include "what should this input object look like", "standardize this output shape", "define the shared policy bundle format", or "what object should downstream skills consume here."
---

# CCFEP IO Contracts

Use this skill to define or inspect the shared object family for CCFEP and downstream workstream skills.

## Layer boundary

Resource layer answers where to find snapshots, sources, and freshness information.

Shared object layer answers:

- what objects look like
- what fields are required
- what failure and escalation states apply
- what consumer order should be used

## Preferred evidence

- `references/index.md`
- `references/io-object-family.md`
- `references/sync-policy.md`
- shared objects already emitted by:
  - `ccfep-request-normalizer`
  - `ccfep-workstream-input-builder`
  - `ccfep-task-output-contract`
  - `ccfep-template-registry`

## Contract-first boundary

- do not own resource path mapping or snapshot freshness
- do not own workflow policy decisions beyond the shape of `policy_bundle_object`
- do not inspect implementation files
- if a needed object shape is missing, define it here first before any coder skill changes implementation

## Fixed shared object family

- `normalized_ccfep_request`
- `ccfep_workstream_input`
- `task_output_contract`
- `simulation_task`
- `secondary_analysis_task`
- `policy_bundle_object`
- `selector_output_object`
- `template_registry_index`
- `template_resolution_result`
- `resource_locator_result`
- `resource_freshness_report`

## Escalation rule

- if the missing piece is resource location or freshness, hand off to `ccfep-resource-catalog`
- if the missing piece is template resolution, hand off to `ccfep-template-registry`
- if a new shared object requires implementation support, hand off to `ccfep-workstream-coder`
