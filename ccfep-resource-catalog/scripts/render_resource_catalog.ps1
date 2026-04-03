param(
    [string]$Scope = "ccfep_shared"
)

$skillRoot = Split-Path -Parent $PSScriptRoot
$referencesRoot = Join-Path $skillRoot "references"

[pscustomobject]@{
    object_type = "resource_catalog"
    scope = $Scope
    resources = @(
        [pscustomobject]@{
            resource_id = "catalog_schema"
            resource_type = "schema_snapshot"
            source_path = ""
            local_snapshot_path = Join-Path $referencesRoot "resource-catalog-schema.md"
            freshness_status = "fresh"
            preferred_consumer = "ccfep-resource-catalog"
            read_order = 1
        }
    )
    failure_state = ""
} | ConvertTo-Json -Depth 6
