# CCFEP Manifest Schema

Use this only when drafting or validating a compact remote-control manifest.

## Minimal schema

```json
{
  "cluster": "ccfep",
  "workstream": "cb | 03_train | domain_stat",
  "task_type": "short_stable_task_label",
  "target_path": "/lustre/home/users/ewu/...",
  "action": "short imperative phrase",
  "inputs": ["direct prerequisite"],
  "expected_outputs": ["durable output or state change"],
  "executor_hint": "cluster_ctl command or local runner",
  "precheck": ["quick validation"]
}
```

## Typical values

### cb

```json
{
  "cluster": "ccfep",
  "workstream": "cb",
  "task_type": "submit_case",
  "target_path": "/lustre/home/users/ewu/cb/14_0/100_350",
  "action": "submit or resume case execution",
  "inputs": ["run.sh", "controller files if needed"],
  "expected_outputs": ["scheduler job id", "updated local receipt"],
  "executor_hint": "py E:/ssh_scp/cluster_ctl.py submit ccfep <local_script> /lustre/home/users/ewu/cb/14_0/100_350",
  "precheck": ["confirm target path exists", "check runtime/state receipts first"]
}
```

### 03_train

```json
{
  "cluster": "ccfep",
  "workstream": "03_train",
  "task_type": "inspect_status",
  "target_path": "/lustre/home/users/ewu/dpmd_work/Gen1_short_range_r2SCAN_D4_700/03_train/dataset_run/RUN9",
  "action": "inspect dataset run and classify next step",
  "inputs": ["canonical remote path", "local receipt state if any"],
  "expected_outputs": ["path classification", "recommended next command or agent"],
  "executor_hint": "py -m cluster_control.commands.list_home --cluster ccfep --remote-dir /lustre/home/users/ewu/dpmd_work/Gen1_short_range_r2SCAN_D4_700/03_train/dataset_run/RUN9",
  "precheck": ["normalize to absolute path", "match against 03_train path families"]
}
```

### domain_stat

```json
{
  "cluster": "ccfep",
  "workstream": "domain_stat",
  "task_type": "inspect_branch",
  "target_path": "/lustre/home/users/ewu/domain_stat/10_5/short_probe",
  "action": "inspect domain-stat branch without assuming first-class automation",
  "inputs": ["remote branch path"],
  "expected_outputs": ["branch summary", "next manual or future-workstream recommendation"],
  "executor_hint": "py -m cluster_control.commands.list_home --cluster ccfep --remote-dir /lustre/home/users/ewu/domain_stat/10_5/short_probe",
  "precheck": ["state clearly that domain_stat is documented but not first-class"]
}
```
