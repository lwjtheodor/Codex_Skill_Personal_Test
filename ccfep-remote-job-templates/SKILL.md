---
name: ccfep-remote-job-templates
description: Use when the user wants a reusable remote job template for CCFEP rather than an ad hoc shell snippet. Typical requests include "draft a PBS job script", "make a reusable remote bash wrapper", "show the job template for this runner", or "what command template should this remote job use."
---

# CCFEP Remote Job Templates

Use this skill to draft remote `.sh` files and structured command templates, especially when the task needs repeatable job-file generation rather than ad hoc shell text.

## Preferred anchors

- `D:/UsersData/s1365/.codex/skills/ccfep-template-registry/references/template-families.md`
- `D:/UsersData/s1365/.codex/skills/ccfep-template-registry/references/template-registry-schema.md`
- `E:/ssh_scp/docs/CCFEP_RUNBOOK.md`
- `E:/ssh_scp/cluster_ctl.py`

## Contract-first boundary

- treat this skill as a shared-object consumer near the template boundary
- prefer `ccfep-template-registry`, local template snapshots, runbook snapshots, and shared object contracts over executor source
- do not inspect Python implementation files unless contract or README evidence is insufficient
- if template snapshots or locators are insufficient, emit `resource_lookup_needed`
- if template implementation support is required, emit `implementation_lookup_needed` and hand off to `ccfep-workstream-coder`

## Layer and authoring rule

- resource layer answers where the template snapshot or runbook snapshot lives
- shared object layer answers what the job-template object and resolution result should look like
- never create a new script in this skill
- never modify executor implementation in this skill

## What this skill owns

- bash script templates
- PBS / `jsub` script templates
- environment activation blocks
- Python CLI argv patterns
- templated command variants for one executor with multiple calling forms

## Preferred evidence

- an existing executor or runner that already emits real remote commands
- a known remote root
- a known Python entrypoint

## When not to use

- do not use when the user only wants a manifest and not the job-file body
- do not use for local-only scripts
- do not use when the proper environment is completely unknown

## Minimal output schema

```json
{
  "job_kind": "bash | pbs_jsub",
  "entrypoint": "",
  "environment_block": [],
  "argv_template": [],
  "script_template": ""
}
```

## Path/file-level expected output

- default inline product: one job-template object plus script body
- if materialized locally, write the metadata object to `E:/ssh_scp/runtime/skills/ccfep/remote_job_templates/<job_slug>.json`
- if a shell script is materialized locally, stage it at `E:/ssh_scp/runtime/skills/ccfep/remote_job_templates/<job_slug>.sh`
- always name the intended remote destination path for the script, for example `/lustre/home/users/ewu/.../<job_slug>.sh`
- `entrypoint` must be a concrete local or remote file path, not only an executor label
- `argv_template` should preserve output-related flags as explicit path-bearing arguments such as `--output-root`, `--remote-root`, or manifest paths

## Ambiguity handling rule

- if environment choice is uncertain, preserve it as an explicit assumption
- if both `conda` and `venv` are plausible, prefer the one already evidenced by the executor or runbook

## Environment patterns

Common patterns already evidenced in this workspace:

- DeepMD Python:
  - `~/venv/dpmd/bin/python`
- analysis Python:
  - `~/venv/MLP_analysis/bin/python`
- remote batch analysis via conda:
  - `module load conda`
  - `conda activate HB_analysis`

## Template rules

- keep module and environment activation in a dedicated block
- keep CLI arguments structured so they can also be represented as `argv`
- for one script with multiple analysis modes, encode variants instead of duplicating whole templates

## Example skeletons

### Bash runner

```bash
#!/bin/bash
set -euo pipefail

module load conda
conda activate HB_analysis

python remote_batch_runner.py --remote-root "$REMOTE_ROOT" --output-root "$OUTPUT_ROOT"
```

### PBS / jsub runner

```bash
#!/bin/bash
#PBS -l select=1:ncpus=32:mpiprocs=32:ompthreads=1
#PBS -j oe

set -euo pipefail
cd "$PBS_O_WORKDIR"

module load conda
conda activate HB_analysis

python remote_batch_runner.py --remote-root "$REMOTE_ROOT" --output-root "$OUTPUT_ROOT"
```
