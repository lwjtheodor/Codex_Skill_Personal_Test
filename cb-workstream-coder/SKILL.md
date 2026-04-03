---
name: cb-workstream-coder
description: Use when a cb script, executor, template implementation, or local helper actually needs to be created or changed. Typical requests include "modify this cb script", "update the LI analysis script", "implement the missing cb executor behavior", "change how this cb analysis runner works", or "wire this new cb template into the existing workflow." This skill is for cb business implementation, not shared platform tooling.
---

# CB Workstream Coder

Use this skill only after a non-coder skill escalates to implementation work for `cb`.

## Owns

- cb executor adaptation
- cb job or script implementation
- cb template implementation and platform-object wiring

## Does not own

- shared locator, sync, validator, or registry infrastructure
- `03_train` or `domain_stat` business scripts

## Policy

- prefer reusing existing cb scripts and templates
- if the missing piece is shared infrastructure, hand off to `ccfep-workstream-coder`
- backfill resource catalog, IO contracts, template registry, and README or capability snapshots after implementation
