---
name: domain-stat-workstream-coder
description: Use when a domain_stat script, executor, template implementation, or local helper actually needs to be created or changed. Typical requests include "modify this domain_stat script", "implement the missing domain_stat executor behavior", or "wire this new domain_stat template into the existing workflow." This skill is for domain_stat business implementation, not shared platform tooling.
---

# Domain Stat Workstream Coder

Use this skill only after a non-coder skill escalates to implementation work for `domain_stat`.

## Owns

- domain_stat executor adaptation
- domain_stat job or script implementation
- domain_stat template implementation and platform-object wiring

## Does not own

- shared locator, sync, validator, or registry infrastructure
- `03_train` or `cb` business scripts

## Policy

- prefer reusing existing domain_stat scripts and templates
- if the missing piece is shared infrastructure, hand off to `ccfep-workstream-coder`
- backfill resource catalog, IO contracts, template registry, and README or capability snapshots after implementation
