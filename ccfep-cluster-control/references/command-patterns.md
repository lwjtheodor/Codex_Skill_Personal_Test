# CCFEP Command Patterns

Use this reference only when selecting concrete remote-control commands.

## Probe

```powershell
py E:\ssh_scp\cluster_ctl.py probe ccfep
```

## Status

```powershell
py E:\ssh_scp\cluster_ctl.py status ccfep
```

## List a remote directory

```powershell
py -m cluster_control.commands.list_home --cluster ccfep --remote-dir <absolute_remote_path>
```

## Upload a local directory

```powershell
py E:\ssh_scp\cluster_ctl.py upload ccfep <local_dir> <remote_parent>
```

## Fetch a remote directory

```powershell
py E:\ssh_scp\cluster_ctl.py fetch ccfep <remote_dir> <local_parent>
```

## Submit a script

```powershell
py E:\ssh_scp\cluster_ctl.py submit ccfep <local_script> <remote_dir>
```

## Receipt-first rule

Check local state first when possible:

- `E:/ssh_scp/runtime/state/cluster_event_log.jsonl`
- `E:/ssh_scp/runtime/state/cluster_event_claims.json`
- `E:/ssh_scp/runtime/state/cluster_state.json`
