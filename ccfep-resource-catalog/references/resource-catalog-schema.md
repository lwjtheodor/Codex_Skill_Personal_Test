# Resource Catalog Schema

## Layer rule

Resource layer answers where to find a thing and whether it is fresh.
Shared object layer answers what the thing should look like after it is found.

## `resource_catalog`

```json
{
  "object_type": "resource_catalog",
  "scope": "",
  "resources": [
    {
      "resource_id": "",
      "resource_type": "",
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

## `resource_locator_result`

```json
{
  "object_type": "resource_locator_result",
  "request_scope": "",
  "matched_resources": [],
  "preferred_next_consumer": "",
  "failure_state": ""
}
```
