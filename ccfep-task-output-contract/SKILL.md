---
name: ccfep-task-output-contract
description: Use when the user wants to know what a CCFEP task should produce when it finishes. Typical requests include "what files should exist after this task", "what counts as complete here", "what results would be worth fetching", or "what should happen next after this task finishes."
---

# CCFEP Task Output Contract

Use this skill to answer "what should exist after this task finishes?" in a protocol-friendly way.

This skill predicts operational consequences, not scientific conclusions.

It should describe:

- expected remote artifacts
- expected local artifacts
- expected receipt or state updates
- completion criteria
- fetch-worthy outputs
- downstream default action

It should not:

- infer scientific findings
- claim a task is complete without evidence
- replace `ccfep-workstream-report` for current-state reporting
- replace `ccfep-event-to-manifest` for drafting a concrete downstream manifest

## Preferred evidence

- one task manifest when available
- `task_type`
- capability group or executor family
- discovery results from `ccfep-workstream-protocol`
- input-builder output from `ccfep-workstream-input-builder` when selector or path-derived inputs matter
- existing local receipts under `E:/ssh_scp/runtime/state/`
- relevant workstream contracts such as `workstream_specs.json`, `path_families.json`, `execution_map.json`, capability registry, downstream policy map, and path-family rules

## Contract-first boundary

- default to task manifests, input-builder output, workstream specs, path families, execution maps, capability registries, downstream policy maps, agent README files, and receipts
- do not inspect Python implementation files unless contract or README evidence is insufficient
- prefer task output contracts, capability registries, downstream policy maps, and agent README over executor source
- if resource snapshots or locators are insufficient, emit `resource_lookup_needed`
- escalate as `implementation_lookup_needed` instead of reading code by default

## Layer and authoring rule

- resource layer answers where to find snapshots, templates, and freshness signals
- shared object layer answers what a task output contract should look like after resources are found
- never create a new script in this skill
- never modify executor implementation in this skill
- if script authoring seems required, hand off to `ccfep-workstream-coder`

## When not to use

- do not use when the user wants current status only; use `ccfep-workstream-report`
- do not use when the main task is immediate execution
- do not use to predict data values, model quality, phase behavior, or other scientific outcomes

## Minimal output schema

```json
{
  "scope": "",
  "task_ref": "",
  "expected_remote_artifacts": [
    {
      "root_path": "",
      "file_patterns": [],
      "required": true
    }
  ],
  "expected_local_artifacts": [
    {
      "root_path": "",
      "file_patterns": [],
      "required": true
    }
  ],
  "receipt_expectations": [
    {
      "root_path": "E:/ssh_scp/runtime/state",
      "file_patterns": [],
      "state_transition": ""
    }
  ],
  "completion_criteria": [],
  "fetch_worthy_outputs": [],
  "downstream_default_action": "fetch_results | workstream_report | handoff_review | none",
  "assumptions": []
}
```

## Path/file-level expected output

- default inline product: one output-contract object
- if materialized locally, write to `E:/ssh_scp/runtime/skills/ccfep/task_output_contract/<task_slug>.json`
- `task_ref` should reference a concrete manifest path, receipt path, or remote root
- every expected artifact entry must include a `root_path`, one or more `file_patterns`, and whether it is required for completion
- `receipt_expectations` should be anchored to `E:/ssh_scp/runtime/state/` unless a different local receipt root is explicitly evidenced
- `fetch_worthy_outputs` should cite concrete remote files or directories that would be pulled back locally, not only output classes

## Contract-writing rule

Prefer contract language such as:

- "should produce"
- "is expected to update"
- "counts as completed when"

Do not use language that implies observed completion unless evidence is present.

## Derivation order

1. consume a concrete manifest if one exists
2. normalize to workstream, path family, task type, and capability
3. use `ccfep-workstream-protocol` results to avoid private routing logic
4. derive output classes and receipt expectations from contract objects such as capability registry, downstream policy map, selector outputs, and the execution surface
5. name the narrowest downstream default action that is justified

## Completion criteria rule

Completion criteria should be operational and auditable.

Prefer criteria such as:

- remote output file exists at an expected location
- executor completion marker or terminal status is recorded
- local receipt shows submitted, running, completed, failed, or fetched transition
- fetch-worthy outputs are stable enough to pull locally

Avoid criteria such as:

- "the run looks scientifically reasonable"
- "the results appear interesting"

## Receipt expectation rule

When describing receipts or state updates, prefer stable event classes over implementation-specific prose.

Examples:

- submit receipt recorded locally
- cluster state updated from queued to running
- completion receipt or terminal job observation recorded
- fetch receipt recorded after local pullback

If the exact receipt filename is unknown, describe the expected state transition rather than inventing one.

Even then, keep the receipt root fixed and narrow the file pattern as much as the evidence allows.

## Downstream bias

Use these defaults unless workstream-specific evidence contradicts them:

- if completion yields fetch-worthy remote outputs not yet local: `fetch_results`
- if outputs are not fetch-worthy or fetch is blocked: `workstream_report`
- if multiple downstream routes are plausible: `handoff_review`
- if the task is purely observational: `none`

## Ambiguity handling rule

- if manifest and capability disagree, prefer the manifest and record the mismatch
- if the executor family is unknown, emit partial contract plus explicit assumptions
- if completion cannot be judged from artifacts alone, say which extra evidence is required

## Shared discovery rule

Do not maintain a private output table disconnected from protocol discovery.

Reuse `ccfep-workstream-protocol` for:

- workstream registration state
- path family
- capability mapping
- implementation presence

Reuse `ccfep-handoff-planner` after completion is established and a routing decision is needed.
