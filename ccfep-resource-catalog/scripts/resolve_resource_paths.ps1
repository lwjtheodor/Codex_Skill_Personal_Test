param(
    [string]$Scope = ""
)

$skillRoot = Split-Path -Parent $PSScriptRoot
$referencesRoot = Join-Path $skillRoot "references"

[pscustomobject]@{
    scope = $Scope
    skill_root = $skillRoot
    references_root = $referencesRoot
    catalog_schema = Join-Path $referencesRoot "resource-catalog-schema.md"
    sync_policy = Join-Path $referencesRoot "sync-policy.md"
} | ConvertTo-Json -Depth 4
