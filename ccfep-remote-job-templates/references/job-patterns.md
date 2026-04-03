# CCFEP Job Patterns

Use this reference when drafting remote shell scripts or structured executor invocation variants.

## PBS / jsub pattern

Observed in `execute_md_postprocess.py`:

- `#!/bin/bash`
- `#PBS -l select=1:ncpus=32:mpiprocs=32:ompthreads=1`
- `cd "$PBS_O_WORKDIR"`
- `module load conda`
- `conda activate HB_analysis`
- `python <runner> <args...>`

## Python argv pattern

Prefer representing Python calls as argv arrays:

```json
{
  "command": "py",
  "argv": [
    "E:/ssh_scp/cluster_ctl.py",
    "fetch",
    "ccfep",
    "<remote_path>",
    "<local_parent>"
  ]
}
```

## Variant rule

When the same entrypoint supports multiple analysis modes, express them as:

```json
{
  "invocation_variants": [
    {
      "variant_id": "racf_from_msd_case",
      "command": "python",
      "argv": ["<entrypoint>", "--analysis", "racf", "--case-root", "<remote_case_root>"]
    },
    {
      "variant_id": "dos_from_dos_case",
      "command": "python",
      "argv": ["<entrypoint>", "--analysis", "dos", "--case-root", "<remote_case_root>"]
    }
  ]
}
```
