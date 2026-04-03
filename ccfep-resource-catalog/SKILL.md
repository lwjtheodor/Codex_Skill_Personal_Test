---
name: ccfep-resource-catalog
description: Use when the task is to find the right CCFEP reference, snapshot, template source, or local resource before doing higher-level reasoning. Typical requests include "where is the source for this snapshot", "which local reference should this skill read first", or "is this resource snapshot missing or stale." This skill only answers where resources are and how fresh they are.
---

# CCFEP Resource Catalog

Use this skill to answer resource-layer questions for CCFEP and downstream workstream skills.

## Layer boundary

Resource layer answers:

- where to find a resource
- what source path it came from
- where the local snapshot lives
- whether the snapshot is fresh enough
- which skill or object layer should consume it first

Shared object layer answers:

- what the resource-derived object should look like
- what fields are required
- how input/output objects are standardized
- what failure and escalation states apply

## Hard scope

This skill only owns:

- resource indexing
- source-to-snapshot mapping
- freshness or drift reporting
- preferred consumer hints
- read order hints

This skill does not own:

- workflow policy
- capability semantics
- task routing
- status vocabularies
- completion logic

## Preferred evidence

- `references/resource-catalog-schema.md`
- `references/index.md`
- `references/sync-policy.md`
- local skill `references/` trees
- local skill `scripts/` trees that act as read-only locators or validators
- upstream source paths under `E:/ssh_scp/...` only when snapshot freshness must be checked

## Contract-first boundary

- default to local skill resources and snapshot metadata first
- do not inspect Python implementation files unless the catalog is explicitly being extended by a coder skill
- never create business rules, workflow policy, or capability logic in this skill
- if a required resource snapshot is missing or stale, emit `resource_lookup_needed`
- if the missing piece is implementation-level rather than resource-level, emit `implementation_lookup_needed`

## Fixed output objects

### `resource_catalog`

```json
{
  "object_type": "resource_catalog",
  "scope": "",
  "resources": [
    {
      "resource_id": "",
      "resource_type": "readme_snapshot | contract_snapshot | schema_snapshot | template_snapshot | policy_snapshot | wrapper_script",
      "source_path": "",
      "local_snapshot_path": "",
      "freshness_status": "fresh | stale | missing | unknown",
      "preferred_consumer": "",
      "read_order": 0
    }
  ],
  "failure_state": ""
}
```

### `resource_locator_result`

```json
{
  "object_type": "resource_locator_result",
  "request_scope": "",
  "matched_resources": [],
  "preferred_next_consumer": "",
  "failure_state": ""
}
```

### `resource_freshness_report`

```json
{
  "object_type": "resource_freshness_report",
  "scope": "",
  "checked_resources": [],
  "stale_resources": [],
  "missing_resources": [],
  "failure_state": ""
}
```

## Escalation rule

- if the answer is "the resource exists but the object shape is unclear", hand off to `ccfep-io-contracts` or `ccfep-template-registry`
- if the answer is "the resource map itself is incomplete", emit `resource_lookup_needed`
- if the answer requires a new locator, sync, or validator implementation, hand off to `ccfep-workstream-coder`
