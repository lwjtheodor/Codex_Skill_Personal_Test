---
name: ccfep-template-registry
description: Use when the task is to choose or explain the right CCFEP template rather than to execute the workflow itself. Typical requests include "which manifest template should this use", "resolve the right handoff template", "what report template applies here", or "which remote job template family fits this task."
---

# CCFEP Template Registry

Use this skill to answer template-layer questions after resources are already located.

## Layer boundary

Resource layer tells you where a template snapshot is.

Shared object layer tells you:

- which template family applies
- what fields the template exposes
- how a template resolution result is shaped

## Preferred evidence

- `references/index.md`
- `references/template-families.md`
- `references/template-registry-schema.md`
- `ccfep-remote-job-templates`
- `ccfep-workstream-manifest`
- `ccfep-workstream-report`
- `ccfep-handoff-planner`

## Contract-first boundary

- do not own source-path mapping or snapshot freshness
- do not own workflow policy
- do not inspect implementation files
- if a template file is missing locally, emit `resource_lookup_needed`
- if the registry shape itself needs implementation support, hand off to `ccfep-workstream-coder`

## Fixed output objects

- `template_registry_index`
- `template_resolution_result`

## Template families

- manifest templates
- report templates
- handoff templates
- remote job templates
- workstream-local task templates
