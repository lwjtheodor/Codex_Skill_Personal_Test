param(
    [string]$LocalSnapshotPath = ""
)

$exists = $LocalSnapshotPath -and (Test-Path $LocalSnapshotPath)
$missingResources = @()

if (-not $exists) {
    $missingResources = @($LocalSnapshotPath)
}

[pscustomobject]@{
    object_type = "resource_freshness_report"
    scope = $LocalSnapshotPath
    checked_resources = @($LocalSnapshotPath)
    stale_resources = @()
    missing_resources = $missingResources
    failure_state = $(if ($exists) { "" } else { "resource_lookup_needed" })
} | ConvertTo-Json -Depth 4
