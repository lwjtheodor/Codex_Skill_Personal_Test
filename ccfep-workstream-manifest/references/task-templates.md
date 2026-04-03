# Audit-Friendly Task Templates

All templates below use the audit-friendly manifest structure.

## Shared shape

```json
{
  "manifest_version": "2",
  "cluster": "ccfep",
  "workstream": "",
  "task_type": "",
  "action": "",
  "targets": {},
  "parameters": {},
  "inputs": {},
  "expected_outputs": {
    "artifacts": {},
    "state_updates": {},
    "constraints": {}
  },
  "executor": {},
  "precheck": [],
  "assumptions": [],
  "risk_level": "",
  "approval_reason": "",
  "trigger_basis": ""
}
```

## classify_remote_path

```json
{
  "manifest_version": "2",
  "cluster": "ccfep",
  "workstream": "cb | 03_train | domain_stat",
  "task_type": "classify_path",
  "action": "classify_remote_path",
  "targets": {
    "remote_path": "/lustre/home/users/ewu/<path>"
  },
  "parameters": {
    "classification_mode": "contract_first"
  },
  "inputs": {
    "remote_paths": [
      "/lustre/home/users/ewu/<path>"
    ]
  },
  "expected_outputs": {
    "artifacts": {
      "classification_record": "workstream + family + next_executor"
    },
    "state_updates": {},
    "constraints": {}
  },
  "executor": {
    "executor_family": "cluster_control_inspection",
    "executor_name": "remote_path_classifier",
    "mode": "inspect_only",
    "command_template": "py -m cluster_control.commands.list_home --cluster ccfep --remote-dir <remote_path>"
  },
  "precheck": [
    {
      "op": "path_is_absolute",
      "path": "/lustre/home/users/ewu/<path>"
    }
  ],
  "assumptions": [],
  "risk_level": "low",
  "approval_reason": "classify a remote path before downstream handling",
  "trigger_basis": "user_requested_path_classification"
}
```

## submit_cb_case

```json
{
  "manifest_version": "2",
  "cluster": "ccfep",
  "workstream": "cb",
  "task_type": "submit_case",
  "action": "submit_cb_case",
  "targets": {
    "remote_case_root": "/lustre/home/users/ewu/cb/<chirality_root>/<pressure>_<temperature>"
  },
  "parameters": {
    "submit_mode": "fresh_or_resume"
  },
  "inputs": {
    "local_submit_script": "<local_script>",
    "required_remote_files_any": [
      "run.sh",
      "superrun.sh"
    ]
  },
  "expected_outputs": {
    "artifacts": {
      "scheduler_job_id": "pbs_job_id"
    },
    "state_updates": {
      "receipt_files": [
        "E:/ssh_scp/runtime/state/cluster_event_log.jsonl",
        "E:/ssh_scp/runtime/state/cluster_state.json"
      ]
    },
    "constraints": {}
  },
  "executor": {
    "executor_family": "cluster_control_submit",
    "executor_name": "cluster_ctl_submit",
    "mode": "submit",
    "command_template": "py E:/ssh_scp/cluster_ctl.py submit ccfep <local_script> <remote_case_root>"
  },
  "precheck": [
    {
      "op": "path_exists",
      "path": "/lustre/home/users/ewu/cb/<chirality_root>/<pressure>_<temperature>"
    },
    {
      "op": "local_file_exists",
      "path": "<local_script>"
    }
  ],
  "assumptions": [],
  "risk_level": "medium",
  "approval_reason": "scheduler submission changes remote execution state",
  "trigger_basis": "user_requested_cb_submission"
}
```

## inspect_cb_case

```json
{
  "manifest_version": "2",
  "cluster": "ccfep",
  "workstream": "cb",
  "task_type": "inspect_case",
  "action": "inspect_cb_case",
  "targets": {
    "remote_case_root": "/lustre/home/users/ewu/cb/<chirality_root>/<pressure>_<temperature>"
  },
  "parameters": {
    "inspect_mode": "case_root"
  },
  "inputs": {
    "remote_paths": [
      "/lustre/home/users/ewu/cb/<chirality_root>/<pressure>_<temperature>"
    ],
    "receipt_files": [
      "E:/ssh_scp/runtime/state/cluster_event_log.jsonl",
      "E:/ssh_scp/runtime/state/cluster_state.json"
    ]
  },
  "expected_outputs": {
    "artifacts": {
      "inspection_record": "case_status_summary",
      "routing_record": "next_agent_or_command"
    },
    "state_updates": {},
    "constraints": {}
  },
  "executor": {
    "executor_family": "cluster_control_inspection",
    "executor_name": "cluster_ctl_list_case",
    "mode": "inspect_only",
    "command_template": "py -m cluster_control.commands.list_home --cluster ccfep --remote-dir <remote_case_root>"
  },
  "precheck": [
    {
      "op": "path_exists",
      "path": "/lustre/home/users/ewu/cb/<chirality_root>/<pressure>_<temperature>"
    }
  ],
  "assumptions": [],
  "risk_level": "low",
  "approval_reason": "inspection is needed before lifecycle or analysis routing",
  "trigger_basis": "user_requested_cb_case_inspection"
}
```

## fetch_cb_analysis

```json
{
  "manifest_version": "2",
  "cluster": "ccfep",
  "workstream": "cb",
  "task_type": "fetch_analysis",
  "action": "fetch_cb_analysis",
  "targets": {
    "remote_analysis_root": "/lustre/home/users/ewu/cb/<analysis_subpath>",
    "local_parent": "<local_parent>"
  },
  "parameters": {
    "fetch_mode": "directory_recursive"
  },
  "inputs": {
    "remote_paths": [
      "/lustre/home/users/ewu/cb/<analysis_subpath>"
    ]
  },
  "expected_outputs": {
    "artifacts": {
      "local_copy_root": "<local_parent>"
    },
    "state_updates": {
      "receipt_files": [
        "E:/ssh_scp/runtime/state/cluster_event_log.jsonl",
        "E:/ssh_scp/runtime/state/cluster_state.json"
      ]
    },
    "constraints": {}
  },
  "executor": {
    "executor_family": "cluster_control_fetch",
    "executor_name": "cluster_ctl_fetch",
    "mode": "fetch",
    "command_template": "py E:/ssh_scp/cluster_ctl.py fetch ccfep <remote_analysis_root> <local_parent>"
  },
  "precheck": [
    {
      "op": "path_exists",
      "path": "/lustre/home/users/ewu/cb/<analysis_subpath>"
    },
    {
      "op": "local_path_ready",
      "path": "<local_parent>"
    }
  ],
  "assumptions": [],
  "risk_level": "medium",
  "approval_reason": "remote analysis artifacts will be copied to local storage",
  "trigger_basis": "user_requested_cb_fetch"
}
```

## route_cb_phase_diagram

```json
{
  "manifest_version": "2",
  "cluster": "ccfep",
  "workstream": "cb",
  "task_type": "route_analysis",
  "action": "route_cb_phase_diagram",
  "targets": {
    "remote_case_root": "/lustre/home/users/ewu/cb/<chirality_root>/<pressure>_<temperature>"
  },
  "parameters": {
    "route_mode": "analysis_router"
  },
  "inputs": {
    "remote_case_root": "/lustre/home/users/ewu/cb/<chirality_root>/<pressure>_<temperature>",
    "optional_analysis_roots": [
      "/lustre/home/users/ewu/cb/LI_out",
      "/lustre/home/users/ewu/cb/cp_results"
    ]
  },
  "expected_outputs": {
    "artifacts": {
      "handoff_record": "branch_plan"
    },
    "state_updates": {},
    "constraints": {}
  },
  "executor": {
    "executor_family": "cb_local_routing",
    "executor_name": "analysis_router",
    "mode": "route_only",
    "entrypoint": "E:/ssh_scp/workstreams/cb/executors/execute_analysis_router.py"
  },
  "precheck": [
    {
      "op": "path_exists",
      "path": "/lustre/home/users/ewu/cb/<chirality_root>/<pressure>_<temperature>"
    }
  ],
  "assumptions": [],
  "risk_level": "low",
  "approval_reason": "analysis branch selection should be auditable",
  "trigger_basis": "case_became_analysis_ready"
}
```

## inspect_cb_phase_diagram_batch

```json
{
  "manifest_version": "2",
  "cluster": "ccfep",
  "workstream": "cb",
  "task_type": "inspect_status",
  "action": "inspect_cb_phase_diagram_batch",
  "targets": {
    "remote_batch_root": "/lustre/home/users/ewu/cb/phase_diagram_batch"
  },
  "parameters": {
    "inspect_mode": "batch_root"
  },
  "inputs": {
    "remote_paths": [
      "/lustre/home/users/ewu/cb/phase_diagram_batch"
    ]
  },
  "expected_outputs": {
    "artifacts": {
      "inspection_record": "batch_status_summary"
    },
    "state_updates": {},
    "constraints": {}
  },
  "executor": {
    "executor_family": "cluster_control_inspection",
    "executor_name": "cluster_ctl_list_phase_batch",
    "mode": "inspect_only",
    "command_template": "py -m cluster_control.commands.list_home --cluster ccfep --remote-dir /lustre/home/users/ewu/cb/phase_diagram_batch"
  },
  "precheck": [
    {
      "op": "path_exists",
      "path": "/lustre/home/users/ewu/cb/phase_diagram_batch"
    }
  ],
  "assumptions": [],
  "risk_level": "low",
  "approval_reason": "inspect production batch branch before fetch or rerun",
  "trigger_basis": "user_requested_cb_phase_batch_inspection"
}
```

## inspect_03_train

```json
{
  "manifest_version": "2",
  "cluster": "ccfep",
  "workstream": "03_train",
  "task_type": "inspect_status",
  "action": "inspect_03_train",
  "targets": {
    "remote_root": "/lustre/home/users/ewu/dpmd_work/Gen1_short_range_r2SCAN_D4_700/03_train/<subpath>"
  },
  "parameters": {
    "inspect_mode": "path_family_classification"
  },
  "inputs": {
    "remote_paths": [
      "/lustre/home/users/ewu/dpmd_work/Gen1_short_range_r2SCAN_D4_700/03_train/<subpath>"
    ]
  },
  "expected_outputs": {
    "artifacts": {
      "classification_record": "03_train_family",
      "routing_record": "next_agent_or_command"
    },
    "state_updates": {},
    "constraints": {}
  },
  "executor": {
    "executor_family": "cluster_control_inspection",
    "executor_name": "cluster_ctl_list_03_train",
    "mode": "inspect_only",
    "command_template": "py -m cluster_control.commands.list_home --cluster ccfep --remote-dir <remote_root>"
  },
  "precheck": [
    {
      "op": "path_is_absolute",
      "path": "/lustre/home/users/ewu/dpmd_work/Gen1_short_range_r2SCAN_D4_700/03_train/<subpath>"
    }
  ],
  "assumptions": [],
  "risk_level": "low",
  "approval_reason": "03_train path needs family classification before follow-up",
  "trigger_basis": "user_requested_03_train_inspection"
}
```

## submit_03_train_dft

```json
{
  "manifest_version": "2",
  "cluster": "ccfep",
  "workstream": "03_train",
  "task_type": "submit_dft",
  "action": "submit_03_train_dft",
  "targets": {
    "remote_dft_root": "/lustre/home/users/ewu/dpmd_work/Gen1_short_range_r2SCAN_D4_700/03_train/DFT_set/DFT_<chir>/RUN*_train"
  },
  "parameters": {
    "submit_mode": "fresh_or_resume"
  },
  "inputs": {
    "local_submit_script": "<local_script>",
    "required_remote_files": [
      "INCAR",
      "KPOINTS",
      "POTCAR",
      "joblist.txt"
    ]
  },
  "expected_outputs": {
    "artifacts": {
      "scheduler_job_id": "pbs_job_id"
    },
    "state_updates": {
      "receipt_files": [
        "E:/ssh_scp/runtime/state/cluster_event_log.jsonl",
        "E:/ssh_scp/runtime/state/cluster_state.json"
      ]
    },
    "constraints": {}
  },
  "executor": {
    "executor_family": "cluster_control_submit",
    "executor_name": "cluster_ctl_submit_dft",
    "mode": "submit",
    "command_template": "py E:/ssh_scp/cluster_ctl.py submit ccfep <local_script> <remote_dft_root>"
  },
  "precheck": [
    {
      "op": "path_exists",
      "path": "/lustre/home/users/ewu/dpmd_work/Gen1_short_range_r2SCAN_D4_700/03_train/DFT_set/DFT_<chir>/RUN*_train"
    },
    {
      "op": "local_file_exists",
      "path": "<local_script>"
    }
  ],
  "assumptions": [],
  "risk_level": "medium",
  "approval_reason": "DFT batch submission changes scheduler state",
  "trigger_basis": "user_requested_dft_submission"
}
```

## validate_03_train_dft

```json
{
  "manifest_version": "2",
  "cluster": "ccfep",
  "workstream": "03_train",
  "task_type": "validate_dft",
  "action": "validate_03_train_dft",
  "targets": {
    "remote_dft_root": "/lustre/home/users/ewu/dpmd_work/Gen1_short_range_r2SCAN_D4_700/03_train/DFT_set/DFT_<chir>/RUN*_train"
  },
  "parameters": {
    "validation_mode": "ingestion_readiness"
  },
  "inputs": {
    "remote_paths": [
      "/lustre/home/users/ewu/dpmd_work/Gen1_short_range_r2SCAN_D4_700/03_train/DFT_set/DFT_<chir>/RUN*_train"
    ]
  },
  "expected_outputs": {
    "artifacts": {
      "validation_record": "dft_readiness_summary"
    },
    "state_updates": {},
    "constraints": {}
  },
  "executor": {
    "executor_family": "03_train_validation",
    "executor_name": "dft_result_validator",
    "mode": "inspect_only",
    "entrypoint": "E:/ssh_scp/workstreams/03_train/executors/execute_dft_result_validator.py"
  },
  "precheck": [
    {
      "op": "path_exists",
      "path": "/lustre/home/users/ewu/dpmd_work/Gen1_short_range_r2SCAN_D4_700/03_train/DFT_set/DFT_<chir>/RUN*_train"
    }
  ],
  "assumptions": [],
  "risk_level": "low",
  "approval_reason": "DFT readiness must be checked before ingestion",
  "trigger_basis": "user_requested_dft_validation"
}
```

## prepare_03_train_dataset

```json
{
  "manifest_version": "2",
  "cluster": "ccfep",
  "workstream": "03_train",
  "task_type": "prepare_training",
  "action": "prepare_03_train_dataset",
  "targets": {
    "remote_dataset_root": "/lustre/home/users/ewu/dpmd_work/Gen1_short_range_r2SCAN_D4_700/03_train/dataset_run/RUN*"
  },
  "parameters": {
    "prepare_mode": "deepmd_config_readiness"
  },
  "inputs": {
    "required_remote_paths": [
      "train",
      "valid"
    ],
    "optional_remote_files": [
      "input.json",
      "check_rep.py"
    ]
  },
  "expected_outputs": {
    "artifacts": {
      "dataset_readiness_record": "deepmd_config_ready"
    },
    "state_updates": {},
    "constraints": {}
  },
  "executor": {
    "executor_family": "03_train_dataset",
    "executor_name": "deepmd_config",
    "mode": "prepare_only",
    "entrypoint": "E:/ssh_scp/workstreams/03_train/executors/execute_deepmd_config.py"
  },
  "precheck": [
    {
      "op": "path_exists",
      "path": "/lustre/home/users/ewu/dpmd_work/Gen1_short_range_r2SCAN_D4_700/03_train/dataset_run/RUN*"
    }
  ],
  "assumptions": [],
  "risk_level": "low",
  "approval_reason": "dataset readiness should be recorded before training",
  "trigger_basis": "user_requested_dataset_preparation"
}
```

## submit_03_train_model

```json
{
  "manifest_version": "2",
  "cluster": "ccfep",
  "workstream": "03_train",
  "task_type": "submit_training",
  "action": "submit_03_train_model",
  "targets": {
    "remote_model_root": "/lustre/home/users/ewu/dpmd_work/Gen1_short_range_r2SCAN_D4_700/03_train/models_r11/model_*"
  },
  "parameters": {
    "submit_mode": "fresh_or_continue"
  },
  "inputs": {
    "required_remote_files": [
      "input.json"
    ],
    "submit_scripts_any": [
      "MLP_train.sh",
      "MLP_train_cont.sh"
    ],
    "local_submit_script": "<local_script>"
  },
  "expected_outputs": {
    "artifacts": {
      "scheduler_job_id": "pbs_job_id",
      "artifact_files_any": [
        "graph.pb",
        "graph_finetuned.pb"
      ]
    },
    "state_updates": {},
    "constraints": {}
  },
  "executor": {
    "executor_family": "cluster_control_submit",
    "executor_name": "cluster_ctl_submit_model",
    "mode": "submit",
    "command_template": "py E:/ssh_scp/cluster_ctl.py submit ccfep <local_script> <remote_model_root>"
  },
  "precheck": [
    {
      "op": "path_exists",
      "path": "/lustre/home/users/ewu/dpmd_work/Gen1_short_range_r2SCAN_D4_700/03_train/models_r11/model_*"
    },
    {
      "op": "local_file_exists",
      "path": "<local_script>"
    }
  ],
  "assumptions": [],
  "risk_level": "medium",
  "approval_reason": "model training submission changes scheduler state",
  "trigger_basis": "user_requested_model_training_submission"
}
```

## inspect_03_train_eval

```json
{
  "manifest_version": "2",
  "cluster": "ccfep",
  "workstream": "03_train",
  "task_type": "inspect_eval",
  "action": "inspect_03_train_eval",
  "targets": {
    "remote_eval_root": "/lustre/home/users/ewu/dpmd_work/Gen1_short_range_r2SCAN_D4_700/03_train/tools/eval*"
  },
  "parameters": {
    "inspect_mode": "evaluation_root"
  },
  "inputs": {
    "remote_paths": [
      "/lustre/home/users/ewu/dpmd_work/Gen1_short_range_r2SCAN_D4_700/03_train/tools/eval*"
    ]
  },
  "expected_outputs": {
    "artifacts": {
      "inspection_record": "evaluation_status_summary"
    },
    "state_updates": {},
    "constraints": {}
  },
  "executor": {
    "executor_family": "cluster_control_inspection",
    "executor_name": "cluster_ctl_list_eval",
    "mode": "inspect_only",
    "command_template": "py -m cluster_control.commands.list_home --cluster ccfep --remote-dir <remote_eval_root>"
  },
  "precheck": [
    {
      "op": "path_is_absolute",
      "path": "/lustre/home/users/ewu/dpmd_work/Gen1_short_range_r2SCAN_D4_700/03_train/tools/eval*"
    }
  ],
  "assumptions": [],
  "risk_level": "low",
  "approval_reason": "evaluation subtree inspection precedes fetch or deployment decision",
  "trigger_basis": "user_requested_eval_inspection"
}
```

## prepare_03_train_fetch

```json
{
  "manifest_version": "2",
  "cluster": "ccfep",
  "workstream": "03_train",
  "task_type": "fetch_results",
  "action": "prepare_03_train_fetch",
  "targets": {
    "remote_subtree": "/lustre/home/users/ewu/dpmd_work/Gen1_short_range_r2SCAN_D4_700/03_train/<subpath>",
    "local_parent": "<local_parent>"
  },
  "parameters": {
    "fetch_mode": "directory_recursive"
  },
  "inputs": {
    "remote_paths": [
      "/lustre/home/users/ewu/dpmd_work/Gen1_short_range_r2SCAN_D4_700/03_train/<subpath>"
    ]
  },
  "expected_outputs": {
    "artifacts": {
      "local_copy_root": "<local_parent>"
    },
    "state_updates": {},
    "constraints": {}
  },
  "executor": {
    "executor_family": "cluster_control_fetch",
    "executor_name": "cluster_ctl_fetch_03_train",
    "mode": "fetch",
    "command_template": "py E:/ssh_scp/cluster_ctl.py fetch ccfep <remote_subtree> <local_parent>"
  },
  "precheck": [
    {
      "op": "path_exists",
      "path": "/lustre/home/users/ewu/dpmd_work/Gen1_short_range_r2SCAN_D4_700/03_train/<subpath>"
    },
    {
      "op": "local_path_ready",
      "path": "<local_parent>"
    }
  ],
  "assumptions": [],
  "risk_level": "medium",
  "approval_reason": "03_train subtree will be copied to local storage",
  "trigger_basis": "user_requested_03_train_fetch"
}
```

## fetch_03_train_model_artifacts

```json
{
  "manifest_version": "2",
  "cluster": "ccfep",
  "workstream": "03_train",
  "task_type": "fetch_results",
  "action": "fetch_03_train_model_artifacts",
  "targets": {
    "remote_model_root": "/lustre/home/users/ewu/dpmd_work/Gen1_short_range_r2SCAN_D4_700/03_train/models_r11/model_*",
    "local_parent": "<local_parent>"
  },
  "parameters": {
    "fetch_mode": "model_artifacts"
  },
  "inputs": {
    "artifact_files_any": [
      "graph.pb",
      "graph_finetuned.pb",
      "checkpoint",
      "lcurve.out"
    ]
  },
  "expected_outputs": {
    "artifacts": {
      "local_copy_root": "<local_parent>"
    },
    "state_updates": {},
    "constraints": {}
  },
  "executor": {
    "executor_family": "cluster_control_fetch",
    "executor_name": "cluster_ctl_fetch_model",
    "mode": "fetch",
    "command_template": "py E:/ssh_scp/cluster_ctl.py fetch ccfep <remote_model_root> <local_parent>"
  },
  "precheck": [
    {
      "op": "path_exists",
      "path": "/lustre/home/users/ewu/dpmd_work/Gen1_short_range_r2SCAN_D4_700/03_train/models_r11/model_*"
    },
    {
      "op": "local_path_ready",
      "path": "<local_parent>"
    }
  ],
  "assumptions": [],
  "risk_level": "medium",
  "approval_reason": "model artifacts will be copied to local storage",
  "trigger_basis": "user_requested_model_artifact_fetch"
}
```

## prepare_md_postprocess_fetch

```json
{
  "manifest_version": "2",
  "cluster": "ccfep",
  "workstream": "03_train",
  "task_type": "prepare_md_postprocess",
  "action": "prepare_md_postprocess_fetch",
  "targets": {
    "remote_root": "/lustre/home/users/ewu/dpmd_work/Gen1_short_range_r2SCAN_D4_700/03_train/MD/Ver*"
  },
  "parameters": {
    "source_family": "md_or_phase_diagram",
    "selection_mode": "manifest_only"
  },
  "inputs": {
    "selector_sources": [
      "case directory names",
      "temperature directory names",
      "available dump files"
    ]
  },
  "expected_outputs": {
    "artifacts": {
      "selection_manifest": "selected_case_manifest",
      "fetch_plan": "fetch_ready_remote_path_list"
    },
    "state_updates": {},
    "constraints": {}
  },
  "executor": {
    "executor_family": "03_train_md_postprocess",
    "executor_name": "md_postprocess_selector",
    "mode": "plan_only",
    "entrypoint": "E:/ssh_scp/workstreams/03_train/developer/MD_postprocess"
  },
  "precheck": [
    {
      "op": "path_is_absolute",
      "path": "/lustre/home/users/ewu/dpmd_work/Gen1_short_range_r2SCAN_D4_700/03_train/MD/Ver*"
    }
  ],
  "assumptions": [],
  "risk_level": "low",
  "approval_reason": "MD_postprocess selection should be explicit before any transfer",
  "trigger_basis": "user_requested_md_postprocess_preparation"
}
```

## fetch_md_postprocess_dumps

```json
{
  "manifest_version": "2",
  "cluster": "ccfep",
  "workstream": "03_train",
  "task_type": "fetch_md_dumps",
  "action": "fetch_md_postprocess_dumps",
  "targets": {
    "remote_case_roots": [
      "/lustre/home/users/ewu/dpmd_work/Gen1_short_range_r2SCAN_D4_700/03_train/<MD_or_phase_subpath>"
    ],
    "local_parent": "<local_parent>"
  },
  "parameters": {
    "fetch_mode": "case_root_with_dump_artifacts"
  },
  "inputs": {
    "required_case_files_any": [
      "dump.mlp.lammpstrj",
      "dump.lammpstrj"
    ]
  },
  "expected_outputs": {
    "artifacts": {
      "local_dump_root": "<local_parent>",
      "mapping_file": "<local_parent>/case_mapping.json"
    },
    "state_updates": {},
    "constraints": {}
  },
  "executor": {
    "executor_family": "cluster_control_fetch",
    "executor_name": "cluster_ctl_fetch_md_dumps",
    "mode": "fetch",
    "command_template": "py E:/ssh_scp/cluster_ctl.py fetch ccfep <remote_case_root> <local_parent>"
  },
  "precheck": [
    {
      "op": "local_path_ready",
      "path": "<local_parent>"
    },
    {
      "op": "selected_case_contains_any",
      "values": [
        "dump.mlp.lammpstrj",
        "dump.lammpstrj"
      ]
    }
  ],
  "assumptions": [
    "fetch_unit=case_root_directory"
  ],
  "risk_level": "medium",
  "approval_reason": "remote dump artifacts will be copied locally for postprocess",
  "trigger_basis": "user_requested_md_dump_fetch"
}
```

## sample_md_postprocess_dumps

```json
{
  "manifest_version": "2",
  "cluster": "ccfep",
  "workstream": "03_train",
  "task_type": "sample_and_fetch_md_dumps",
  "action": "sample_md_postprocess_dumps",
  "targets": {
    "remote_root": "/lustre/home/users/ewu/dpmd_work/Gen1_short_range_r2SCAN_D4_700/03_train/phase_diagram_v10",
    "local_parent": "<local_parent>"
  },
  "parameters": {
    "workflow_family": "MD_postprocess",
    "source_family": "phase_diagram_v10",
    "temperature_start_k": 200,
    "temperature_step_k": 100,
    "sample_count_per_group": 6,
    "sampling_scope": "per_chirality_per_temperature",
    "sampling_strategy": "density_span_then_uniform",
    "density_proxy": {
      "type": "case_name_suffix",
      "field": "N"
    }
  },
  "inputs": {
    "chirality_roots": [
      "/lustre/home/users/ewu/dpmd_work/Gen1_short_range_r2SCAN_D4_700/03_train/phase_diagram_v10/10_5",
      "/lustre/home/users/ewu/dpmd_work/Gen1_short_range_r2SCAN_D4_700/03_train/phase_diagram_v10/12_4",
      "/lustre/home/users/ewu/dpmd_work/Gen1_short_range_r2SCAN_D4_700/03_train/phase_diagram_v10/14_0"
    ],
    "required_case_files_any": [
      "dump.mlp.lammpstrj",
      "dump.lammpstrj"
    ]
  },
  "expected_outputs": {
    "artifacts": {
      "selection_manifest_file": "<local_parent>/md_postprocess_selection_manifest.json",
      "case_mapping_file": "<local_parent>/md_postprocess_case_mapping.json",
      "local_dump_root": "<local_parent>"
    },
    "state_updates": {},
    "constraints": {
      "fetched_case_count_rule": "6_per_chirality_per_temperature"
    }
  },
  "executor": {
    "executor_family": "md_postprocess_fetch",
    "executor_name": "phase_diagram_sampler_fetcher",
    "mode": "plan_then_fetch",
    "entrypoint": "E:/ssh_scp/workstreams/03_train/developer/MD_postprocess",
    "invocation": {
      "type": "template",
      "command": "py",
      "argv": [
        "<md_postprocess_entrypoint>",
        "<task_record_json>"
      ]
    },
    "invocation_variants": [
      {
        "variant_id": "enumerate_temperature_root",
        "type": "cli",
        "command": "py",
        "argv": [
          "-m",
          "cluster_control.commands.list_home",
          "--cluster",
          "ccfep",
          "--remote-dir",
          "<temperature_dir>"
        ]
      },
      {
        "variant_id": "fetch_case_root",
        "type": "cli",
        "command": "py",
        "argv": [
          "E:/ssh_scp/cluster_ctl.py",
          "fetch",
          "ccfep",
          "<remote_case_root>",
          "<local_parent>"
        ]
      }
    ]
  },
  "precheck": [
    {
      "op": "path_exists",
      "path": "/lustre/home/users/ewu/dpmd_work/Gen1_short_range_r2SCAN_D4_700/03_train/phase_diagram_v10"
    },
    {
      "op": "local_path_ready",
      "path": "<local_parent>"
    },
    {
      "op": "selected_case_contains_any",
      "values": [
        "dump.mlp.lammpstrj",
        "dump.lammpstrj"
      ]
    }
  ],
  "assumptions": [
    "sampling_scope=per_chirality_per_temperature",
    "fetch_unit=case_root_directory"
  ],
  "risk_level": "medium",
  "approval_reason": "bulk dump sampling and fetch requires explicit audited selection policy",
  "trigger_basis": "user_requested_md_postprocess_sampling_fetch"
}
```

## analyze_phase_diagram_completed_cases

```json
{
  "manifest_version": "2",
  "cluster": "ccfep",
  "workstream": "03_train",
  "task_type": "analyze_completed_cases",
  "action": "analyze_phase_diagram_completed_cases",
  "targets": {
    "remote_root": "/lustre/home/users/ewu/dpmd_work/Gen1_short_range_r2SCAN_D4_700/03_train/phase_diagram_v10",
    "local_parent": "<local_parent>"
  },
  "parameters": {
    "source_family": "phase_diagram_v10",
    "completion_requirements": [
      "msd_completed",
      "dos_completed"
    ],
    "analysis_dispatch": {
      "msd": "racf",
      "dos": "dos"
    }
  },
  "inputs": {
    "selector_manifest": "<selector_manifest_json>",
    "required_case_markers": [
      "msd_completed",
      "dos_completed"
    ]
  },
  "expected_outputs": {
    "artifacts": {
      "analysis_manifest_file": "<local_parent>/phase_diagram_completed_analysis_manifest.json",
      "analysis_result_index": "<local_parent>/phase_diagram_completed_analysis_index.json"
    },
    "state_updates": {},
    "constraints": {
      "dispatch_rule": "msd_cases_to_racf,dos_cases_to_dos"
    }
  },
  "executor": {
    "executor_family": "phase_diagram_analysis_dispatch",
    "executor_name": "shared_cli_dispatcher",
    "mode": "branch_dispatch",
    "entrypoint": "<shared_analysis_entrypoint>",
    "invocation": {
      "type": "template",
      "command": "py",
      "argv": [
        "<shared_analysis_entrypoint>",
        "<task_record_json>"
      ]
    },
    "invocation_variants": [
      {
        "variant_id": "racf_from_msd_case",
        "type": "cli",
        "command": "py",
        "argv": [
          "<shared_analysis_entrypoint>",
          "--analysis",
          "racf",
          "--case-root",
          "<remote_case_root>",
          "--source-tag",
          "msd"
        ]
      },
      {
        "variant_id": "dos_from_dos_case",
        "type": "cli",
        "command": "py",
        "argv": [
          "<shared_analysis_entrypoint>",
          "--analysis",
          "dos",
          "--case-root",
          "<remote_case_root>",
          "--source-tag",
          "dos"
        ]
      }
    ]
  },
  "precheck": [
    {
      "op": "path_exists",
      "path": "/lustre/home/users/ewu/dpmd_work/Gen1_short_range_r2SCAN_D4_700/03_train/phase_diagram_v10"
    },
    {
      "op": "local_path_ready",
      "path": "<local_parent>"
    }
  ],
  "assumptions": [
    "shared_analysis_entrypoint_supports_analysis_flag",
    "case_completion_labels_are_available_in_selector_manifest"
  ],
  "risk_level": "medium",
  "approval_reason": "completed phase-diagram cases require branch-specific analysis dispatch through CLI variants",
  "trigger_basis": "user_requested_completed_case_analysis_dispatch"
}
```

## dispatch_md_postprocess_marker_analyses

```json
{
  "manifest_version": "2",
  "cluster": "ccfep",
  "workstream": "03_train",
  "task_type": "md_postprocess_dispatch",
  "action": "dispatch_md_postprocess_marker_analyses",
  "targets": {
    "remote_root": "/lustre/home/users/ewu/dpmd_work/Gen1_short_range_r2SCAN_D4_700/03_train/phase_diagram_v10/<chirality>",
    "local_parent": "<local_parent>"
  },
  "parameters": {
    "completion_marker": "restart.mlp",
    "dispatch_variants": [
      "racf",
      "dos"
    ],
    "dump_conventions": {
      "racf": "dump.msd20ps_racf.lammpstrj",
      "dos": "dump.dos5ps_vel.lammpstrj"
    }
  },
  "inputs": {
    "remote_root": "/lustre/home/users/ewu/dpmd_work/Gen1_short_range_r2SCAN_D4_700/03_train/phase_diagram_v10/<chirality>",
    "required_case_markers": [
      "restart.mlp"
    ],
    "required_case_files_any": [
      "dump.msd20ps_racf.lammpstrj",
      "dump.dos5ps_vel.lammpstrj"
    ]
  },
  "expected_outputs": {
    "artifacts": {
      "dispatch_artifact": "<local_parent>/md_postprocess_dispatch_<batch>.json",
      "racf_batch_manifest_json": "<local_parent>/racf/remote_results/<batch>_racf_results/batch_manifest.json",
      "dos_batch_manifest_json": "<local_parent>/dos/remote_results/<batch>_dos_results/batch_manifest.json"
    },
    "state_updates": {},
    "constraints": {
      "dispatch_rule": "racf_cases_use_dump.msd20ps_racf.lammpstrj,dos_cases_use_dump.dos5ps_vel.lammpstrj"
    }
  },
  "executor": {
    "executor_family": "03_train_md_postprocess",
    "executor_name": "md_postprocess_dispatch",
    "mode": "dispatch_then_batch",
    "entrypoint": "E:/ssh_scp/workstreams/03_train/executors/execute_md_postprocess_dispatch.py",
    "invocation": {
      "type": "cli",
      "command": "py",
      "argv": [
        "E:/ssh_scp/workstreams/03_train/executors/execute_md_postprocess_dispatch.py",
        "--remote-root",
        "<remote_root>",
        "--output-dir",
        "<local_parent>"
      ]
    },
    "invocation_variants": [
      {
        "variant_id": "dispatch_racf_only",
        "type": "cli",
        "command": "py",
        "argv": [
          "E:/ssh_scp/workstreams/03_train/executors/execute_md_postprocess_dispatch.py",
          "--remote-root",
          "<remote_root>",
          "--output-dir",
          "<local_parent>",
          "--run-racf"
        ]
      },
      {
        "variant_id": "dispatch_dos_only",
        "type": "cli",
        "command": "py",
        "argv": [
          "E:/ssh_scp/workstreams/03_train/executors/execute_md_postprocess_dispatch.py",
          "--remote-root",
          "<remote_root>",
          "--output-dir",
          "<local_parent>",
          "--run-dos"
        ]
      }
    ]
  },
  "precheck": [
    {
      "op": "path_exists",
      "path": "/lustre/home/users/ewu/dpmd_work/Gen1_short_range_r2SCAN_D4_700/03_train/phase_diagram_v10/<chirality>"
    },
    {
      "op": "local_path_ready",
      "path": "<local_parent>"
    }
  ],
  "assumptions": [
    "racf_and_dos_dispatch_are_intentionally_split_into_separate_md_postprocess_batches"
  ],
  "risk_level": "medium",
  "approval_reason": "mixed completed cases require audited split dispatch by dump marker convention",
  "trigger_basis": "user_requested_phase_diagram_marker_dispatch"
}
```

## handle_domain_stat

```json
{
  "manifest_version": "2",
  "cluster": "ccfep",
  "workstream": "domain_stat",
  "task_type": "inspect_branch",
  "action": "handle_domain_stat",
  "targets": {
    "remote_branch_root": "/lustre/home/users/ewu/domain_stat/<subpath>"
  },
  "parameters": {
    "inspect_mode": "documented_branch_only"
  },
  "inputs": {
    "remote_paths": [
      "/lustre/home/users/ewu/domain_stat/<subpath>"
    ]
  },
  "expected_outputs": {
    "artifacts": {
      "inspection_record": "domain_stat_branch_summary"
    },
    "state_updates": {},
    "constraints": {}
  },
  "executor": {
    "executor_family": "cluster_control_inspection",
    "executor_name": "cluster_ctl_list_domain_stat",
    "mode": "inspect_only",
    "command_template": "py -m cluster_control.commands.list_home --cluster ccfep --remote-dir <remote_branch_root>"
  },
  "precheck": [
    {
      "op": "path_exists",
      "path": "/lustre/home/users/ewu/domain_stat/<subpath>"
    }
  ],
  "assumptions": [
    "domain_stat_is_documented_but_not_first_class"
  ],
  "risk_level": "low",
  "approval_reason": "documented branch should be handled with explicit caveat",
  "trigger_basis": "user_requested_domain_stat_handling"
}
```

## inspect_domain_stat_probe

```json
{
  "manifest_version": "2",
  "cluster": "ccfep",
  "workstream": "domain_stat",
  "task_type": "inspect_probe",
  "action": "inspect_domain_stat_probe",
  "targets": {
    "remote_probe_root": "/lustre/home/users/ewu/domain_stat/<chirality>/<short_probe|long_probe>"
  },
  "parameters": {
    "inspect_mode": "probe_root"
  },
  "inputs": {
    "remote_paths": [
      "/lustre/home/users/ewu/domain_stat/<chirality>/<short_probe|long_probe>"
    ]
  },
  "expected_outputs": {
    "artifacts": {
      "inspection_record": "probe_summary"
    },
    "state_updates": {},
    "constraints": {}
  },
  "executor": {
    "executor_family": "cluster_control_inspection",
    "executor_name": "cluster_ctl_list_domain_probe",
    "mode": "inspect_only",
    "command_template": "py -m cluster_control.commands.list_home --cluster ccfep --remote-dir <remote_probe_root>"
  },
  "precheck": [
    {
      "op": "path_exists",
      "path": "/lustre/home/users/ewu/domain_stat/<chirality>/<short_probe|long_probe>"
    }
  ],
  "assumptions": [
    "domain_stat_is_documented_but_not_first_class"
  ],
  "risk_level": "low",
  "approval_reason": "probe branch inspection should preserve documented-only status",
  "trigger_basis": "user_requested_domain_probe_inspection"
}
```

## fetch_domain_stat_outputs

```json
{
  "manifest_version": "2",
  "cluster": "ccfep",
  "workstream": "domain_stat",
  "task_type": "fetch_results",
  "action": "fetch_domain_stat_outputs",
  "targets": {
    "remote_branch_root": "/lustre/home/users/ewu/domain_stat/<subpath>",
    "local_parent": "<local_parent>"
  },
  "parameters": {
    "fetch_mode": "directory_recursive"
  },
  "inputs": {
    "remote_paths": [
      "/lustre/home/users/ewu/domain_stat/<subpath>"
    ]
  },
  "expected_outputs": {
    "artifacts": {
      "local_copy_root": "<local_parent>"
    },
    "state_updates": {},
    "constraints": {}
  },
  "executor": {
    "executor_family": "cluster_control_fetch",
    "executor_name": "cluster_ctl_fetch_domain_stat",
    "mode": "fetch",
    "command_template": "py E:/ssh_scp/cluster_ctl.py fetch ccfep <remote_branch_root> <local_parent>"
  },
  "precheck": [
    {
      "op": "path_exists",
      "path": "/lustre/home/users/ewu/domain_stat/<subpath>"
    },
    {
      "op": "local_path_ready",
      "path": "<local_parent>"
    }
  ],
  "assumptions": [
    "domain_stat_is_documented_but_not_first_class"
  ],
  "risk_level": "medium",
  "approval_reason": "domain_stat outputs will be copied locally under documented-branch handling",
  "trigger_basis": "user_requested_domain_stat_fetch"
}
```
