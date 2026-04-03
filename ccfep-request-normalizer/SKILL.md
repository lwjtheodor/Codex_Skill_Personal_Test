---
name: ccfep-request-normalizer
description: Use when the user describes a CCFEP task in loose language and Codex first needs to pin down what they mean. Typical requests include "inspect this RUN and prepare the next step", "find DOS-ready cases under this branch", "route this case after convergence", "sync the updated local analysis script to the remote cb folder and run it", or "use the new local script version on ccfep and start the analysis." This skill turns that natural-language request into a stable machine-readable object for downstream skills.
---

# CCFEP Request Normalizer

Turn natural-language CCFEP requests into a small, explicit request object that downstream layers can consume without reinterpreting the user's intent.

This skill fills the gap between:

- protocol discovery
- final manifest drafting
- handoff or execution routing

It should not replace those layers.

## Use This Skill For

Use this skill when the user gives a descriptive request such as:

- "Inspect `DP_SYS/systems_MLP_MD_10_5/RUN12` and prepare candidates for the next DFT step."
- "Use `restart.mlp` and `dump.dos5ps_vel.lammpstrj` to find DOS-ready cases under a phase diagram branch."
- "Route this cb case into the downstream MSD support-analysis path after convergence."

Use it when the hard part is to stabilize meaning, not to execute immediately.

Do not use it when:

- the target downstream skill is already obvious and already has a fully specified input object
- the user only wants live cluster inspection
- the main deliverable is the final execution manifest rather than the normalized request

## Core Job

Produce one compact request object that does four things in order:

1. extract task markers from the user's wording
2. map those markers onto workstream, path family, and downstream capability
3. expand rule-derived fields such as normalized paths, artifact expectations, and routing hints
4. emit a handoff-ready object for another skill, agent, or executor

Treat marker extraction as a contract step, not a casual summary step.

## Preferred Evidence

Read only what is needed, in this order:

1. `E:/ssh_scp/cluster_control/contracts/workstream_specs.json`
2. target `path_families.json`
3. target `execution_map.json`
4. relevant agent README when downstream boundary is still unclear
5. `references/request-object-schema.md`
6. `references/skill-interface-cheatsheet.md`
7. `D:/UsersData/s1365/.codex/skills/ccfep-workstream-input-builder/references/input-object-schema.md` when the next layer needs a fixed selector or policy bundle

## Contract-first boundary

- default to workstream specs, path families, execution maps, agent README, the request-object schema, and input-object schema references
- do not inspect Python implementation files unless contract or README evidence is insufficient
- prefer specs, path families, execution maps, and agent README over executor source
- if resource snapshots or locators are insufficient, emit `resource_lookup_needed`
- escalate as `implementation_lookup_needed` instead of reading code by default

## Layer and authoring rule

- resource layer answers where to find a source, snapshot, or freshness check
- shared object layer answers what the normalized or downstream object should look like
- never create a new script in this skill
- never modify executor implementation in this skill
- if script authoring seems required, hand off to `ccfep-workstream-coder`

If the request names a concrete path, normalize and classify that path before doing anything else.

## Marker Classes

Look for markers in four buckets:

- path markers
  - explicit remote roots
  - partial remote fragments such as `DP_SYS/.../RUN12`
  - stable branch names such as `phase_diagram_v10`
- intent markers
  - inspect
  - summarize
  - prepare
  - route
  - fetch
  - register
  - validate
- artifact markers
  - filenames or branch artifacts such as `all_features.csv`, `candidate_list*.csv`, `restart.mlp`, `dump.msd20ps_racf.lammpstrj`
- policy markers
  - budgets, split rules, case filters, required completion criteria, or downstream target constraints

Keep the extracted marker list explicit in the output object. Do not bury it in prose.

## Normalization Procedure

1. Identify whether the request is path-led, artifact-led, or intent-led.
2. Resolve the workstream through root contracts or stable branch markers.
3. Classify the strongest matching path family.
4. Resolve the downstream capability or agent from the execution map.
5. Expand missing but derivable fields into machine-oriented inputs.
6. Emit a single fixed request object.
7. If ambiguity remains, emit the object anyway and set the ambiguity fields instead of silently guessing.

Prefer "partial but explicit" over "smooth but hidden".

## Fixed Output Object

Use the schema in [request-object-schema.md](./references/request-object-schema.md).

Default output shape:

```json
{
  "request_type": "normalized_ccfep_request",
  "source_text": "",
  "workstream": "",
  "registered_status": "",
  "path_resolution": {
    "input_paths": [],
    "normalized_paths": [],
    "path_family": "",
    "path_family_confidence": 0.0
  },
  "markers": {
    "path_markers": [],
    "intent_markers": [],
    "artifact_markers": [],
    "policy_markers": []
  },
  "routing": {
    "capability_group": "",
    "preferred_agent": "",
    "preferred_skill": "",
    "preferred_executor": "",
    "handoff_mode": "skill | agent | executor | review"
  },
  "resolved_inputs": {},
  "required_evidence": [],
  "expected_outputs": [
    {
      "kind": "draft | manifest | report | handoff | remote_artifact",
      "root_path": "",
      "file_patterns": [],
      "consumer": ""
    }
  ],
  "ambiguities": [],
  "failure_state": "",
  "next_step_hint": ""
}
```

## Path/file-level expected output

- default inline product: one normalized request object
- if materialized locally, write to `E:/ssh_scp/runtime/skills/ccfep/request_normalizer/<request_slug>.json`
- `path_resolution.normalized_paths` must use absolute remote paths when derivable
- `resolved_inputs` should preserve concrete roots, filenames, and file patterns a downstream consumer should inspect or write
- `required_evidence` should name missing files or paths, not only evidence classes
- `expected_outputs` must be path/file-oriented descriptors with `root_path`, `file_patterns`, and `consumer`
- downstream skills should be able to draft their artifact without re-inferring the target path layout

This object is the product.

Do not inflate it into a full manifest unless the user asks for manifest-level output.

## Field Rules

- `source_text`
  - copy the operative request text or a tight paraphrase if the request is very long
- `workstream`
  - must come from registered contracts when possible
- `registered_status`
  - mirror protocol vocabulary
- `path_resolution.normalized_paths`
  - use absolute remote style when derivable
- `markers.*`
  - keep raw marker strings compact and literal
- `routing.preferred_skill`
  - name the downstream skill only when one of the installed skills is clearly the next consumer
- `resolved_inputs`
  - store the exact fields a downstream consumer should not have to reconstruct
- `required_evidence`
  - name evidence still needed for safe downstream action
- `expected_outputs`
  - keep these as downstream-facing path/file descriptors, not long explanations
- `ambiguities`
  - list unresolved branchings explicitly
- `failure_state`
  - use protocol-style explicit failures such as `unregistered_workstream`, `unknown_path_family`, `no_execution_route`, or `insufficient_markers`

## Handoff Rule

When the object is stable enough, hand off to the narrowest next layer:

- use `ccfep-workstream-input-builder` when selectors, policy bundles, completion cues, or exact downstream `inputs` still need to be stabilized
- use `ccfep-workstream-manifest` when the user wants an execution-ready record
- use `ccfep-handoff-planner` when the next action is the actual question
- use workstream-local task skills when the path family and downstream artifact contract are already clear
- use `ccfep-workstream-protocol` only when registration or compatibility is still unresolved

This skill ends after constructing the normalized request object unless the user explicitly asks for the next layer too.

## Boundary

- Do not become a universal router for every downstream action.
- Do not execute cluster commands just because the route is known.
- Do not invent scientific conclusions from marker words alone.
- Do not hide uncertainty inside natural-language recommendations.
