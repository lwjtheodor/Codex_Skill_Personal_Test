---
name: ccfep-cluster-control
description: Use when the user wants to do something directly on the CCFEP supercomputer or inspect its current state. Typical requests include "check the cluster status", "show disk usage", "run showlim -d", "list a remote folder", "check what is on the cluster right now", "fetch results", "upload this folder to ccfep", "sync these scripts to the remote machine", "submit a job", "start this remote analysis", or "which cluster_ctl command should I use for this path." Do not use this skill as the main manifest-drafting layer.
---

# CCFEP Cluster Control

Use this skill for `ccfep`, `cluster_control`, `cluster_ctl.py`, remote supercomputer operations, path inspection, and command selection.

## What this skill owns

- canonical `ccfep` control facts
- remote root classification
- command selection through `cluster_ctl.py`
- first-pass routing into `cb`, `03_train`, or lightweight `domain_stat`
- consumption of normalized request objects when command selection starts from a descriptive request

## Workspace anchors

Prefer these files in the current workspace:

- `E:/ssh_scp/cluster_control/contracts/workstream_specs.json`
- `E:/ssh_scp/docs/ccfep_cluster_control_reuse.json`
- `E:/ssh_scp/docs/CCFEP_SHORT_MANUAL.md`
- `E:/ssh_scp/docs/playbooks/submit_cb_case.md`
- `E:/ssh_scp/docs/playbooks/inspect_03_train.md`
- `E:/ssh_scp/docs/playbooks/handle_domain_stat.md`
- `E:/ssh_scp/cluster_ctl.py`

## Layer and authoring rule

- resource layer answers where cluster-control docs, playbooks, and snapshots live
- shared object layer answers what normalized requests, manifests, and command recommendation objects should look like
- never create a new script in this skill
- never modify executor implementation in this skill
- if shared wrapper or locator implementation is required, hand off to `ccfep-workstream-coder`

If the workspace root differs, search for:

- `ccfep_cluster_control_reuse.json`
- `CCFEP_SHORT_MANUAL.md`
- `docs/playbooks`

## Default procedure

1. If the request is free-form, first consume the normalized request object from `ccfep-request-normalizer`.
2. Load the canonical JSON first when exact routing, paths, or command forms matter.
3. Follow the same discovery logic defined by `ccfep-workstream-protocol`.
4. Load `cluster_control/contracts/workstream_specs.json` to discover registered workstreams before assuming fixed names.
5. Resolve the target workstream's `path_families.json` and `execution_map.json`.
6. Use the short manual for fast context only if the JSON is more detail than needed.
7. Use a playbook when the task matches an existing pattern.
8. Normalize all remote paths to absolute `/lustre/home/users/ewu/...` form before writing manifests or commands.
9. Prefer local receipts under `runtime/state/` before asking the cluster again.
10. If the main output should be a task manifest, switch to `ccfep-workstream-manifest`.

## Interface rule

When a normalized request object is present:

- trust `markers`, `path_resolution`, and `resolved_inputs` as the upstream interpretation layer
- verify paths and execution routes against contracts before issuing commands
- add command recommendations or receipt lookups without rewriting the request object's meaning

## Workstream routing

Use this discovery order:

1. `ccfep-workstream-protocol`
2. `cluster_control/contracts/workstream_specs.json`
3. target workstream `path_families.json`
4. target workstream `execution_map.json`
5. target agent README or executor
6. fallback lightweight or experimental branches such as `domain_stat` or `protocol_sandbox`

Current known first-class workstreams:

- `cb`
- `03_train`

Current lightweight workstream:

- `domain_stat`

Current experimental fixture:

- `protocol_sandbox`

## Command selection

Default commands:

```powershell
py E:\ssh_scp\cluster_ctl.py probe ccfep
py E:\ssh_scp\cluster_ctl.py status ccfep
py E:\ssh_scp\cluster_ctl.py upload ccfep <local_dir> <remote_parent>
py E:\ssh_scp\cluster_ctl.py fetch ccfep <remote_dir> <local_parent>
py E:\ssh_scp\cluster_ctl.py submit ccfep <local_script> <remote_dir>
py -m cluster_control.commands.list_home --cluster ccfep --remote-dir <path>
```

## Path/file-level expected output

- default inline product: one command-and-path recommendation record
- if materialized locally, write to `E:/ssh_scp/runtime/skills/ccfep/cluster_control/<request_slug>.json`
- every recommended command must point to absolute paths only:
  - local paths under `E:/ssh_scp/...`
  - remote paths under `/lustre/home/users/ewu/...`
- when the task includes receipt lookup, cite the concrete local receipt path under `E:/ssh_scp/runtime/state/`
- when the task includes remote inspection, cite the concrete remote root or remote file pattern being inspected
- when the task is being routed onward, name the downstream artifact and its expected local draft path:
  - manifest draft -> `E:/ssh_scp/runtime/skills/ccfep/workstream_manifest/<request_slug>.manifest.json`
  - status report -> `E:/ssh_scp/runtime/skills/ccfep/workstream_report/<request_slug>.json`
  - handoff record -> `E:/ssh_scp/runtime/skills/ccfep/handoff_planner/<request_slug>.json`

## Token discipline

- do not restate the whole repo layout if the JSON already covers it
- do not reload long docs unless the task needs them
- prefer emitting 1-3 recommended commands plus only the minimum route/context needed
- keep lightweight and experimental caveats short but explicit
