---
name: ccfep-workstream-coder
description: Use when shared CCFEP infrastructure actually needs code changes. Typical requests include "implement a shared locator", "fix the resource sync tool", "add support to the template registry implementation", or "change the shared wrapper behavior." This skill is only for platform-level implementation, not 03train, cb, or domain_stat business scripts.
---

# CCFEP Workstream Coder

Use this skill only for platform-layer implementation work.

## Owns

- cluster-control adapters
- shared locator, exporter, validator, and sync tools
- resource catalog implementation support
- shared object registry implementation support
- template registry implementation support

## Does not own

- `03train` business scripts
- `cb` business scripts
- `domain_stat` business scripts

## Policy

- prefer reusing existing shared wrappers and templates over creating new scripts
- create or modify scripts only when a non-coder skill has already escalated to `implementation_lookup_needed`
- after any implementation change, backfill resource catalog, IO contracts, template registry, and README or capability snapshots
