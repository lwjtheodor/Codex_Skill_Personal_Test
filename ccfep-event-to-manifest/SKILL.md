---
name: ccfep-event-to-manifest
description: Use when the user wants to turn a receipt, completion event, or state change into the next CCFEP task record. Typical requests include "make the next manifest from this completion event", "turn this receipt into a follow-up task", or "draft the downstream manifest after this state change."
---

# CCFEP Event To Manifest

Use this skill to convert an event or state transition into a new manifest draft.

## Preferred evidence

- normalized request object from `ccfep-request-normalizer` when the upstream event was described in natural language
- input-builder output from `ccfep-workstream-input-builder` when the event must be turned into precise `inputs`
- one concrete upstream event or receipt
- one clearly identified target path or run root
- one known downstream workflow family
- discovery results from `ccfep-workstream-protocol`

## Contract-first boundary

- default to normalized request objects, input-builder output, protocol discovery, manifest schema, task templates, and task output contracts
- do not inspect Python implementation files unless contract or README evidence is insufficient
- prefer specs, path families, execution maps, task templates, and agent README over executor source
- if resource snapshots or locators are insufficient, emit `resource_lookup_needed`
- escalate as `implementation_lookup_needed` instead of reading code by default

## Layer and authoring rule

- never create a new script in this skill
- never modify executor implementation in this skill
- if script authoring seems required, hand off to `ccfep-workstream-coder`

## When not to use

- do not use when there is no concrete event basis
- do not use when the user wants a free-form plan rather than a manifest
- do not use when execution should happen immediately without an audit object

## Minimal output schema

```json
{
  "request_ref": "",
  "trigger_basis": "",
  "derived_workstream": "",
  "derived_task_type": "",
  "manifest": {}
}
```

## Path/file-level expected output

- default inline product: one manifest draft object
- if materialized locally, write to `E:/ssh_scp/runtime/skills/ccfep/event_to_manifest/<event_slug>.manifest.json`
- `request_ref` should reference either a normalized request object path under `E:/ssh_scp/runtime/skills/ccfep/request_normalizer/` or a concrete upstream receipt or event-log path under `E:/ssh_scp/runtime/state/`
- `trigger_basis` must include the concrete triggering file or remote path, not only a human summary
- `manifest.targets`, `manifest.inputs`, and `manifest.expected_outputs` must preserve absolute remote roots and explicit file names or file patterns

## Ambiguity handling rule

- if one event can map to multiple downstream actions, emit the most conservative manifest and record assumptions
- if downstream mapping is too uncertain, stop at a candidate manifest and mark it for review

## Shared discovery rule

Do not keep a private event-to-workstream mapping table here.

Reuse protocol-layer discovery for:

- workstream registration state
- path family mapping
- capability route
- graceful failure states such as `unknown_path_family` or `no_execution_route`

Reuse request-normalizer outputs for:

- canonical path fragments
- resolved input bundles
- downstream target hints

## Inputs

- cluster event receipt
- cluster state change
- upstream completion signal

## Output

- one audit-friendly manifest draft
- materializable at `E:/ssh_scp/runtime/skills/ccfep/event_to_manifest/<event_slug>.manifest.json`

Always record:

- trigger basis
- approval reason
- risk level
- assumptions if interpretation is needed

If a normalized request object is already available, manifest drafting should consume that object first and only then merge in event-specific trigger information.
