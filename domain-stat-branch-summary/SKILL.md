---
name: domain-stat-branch-summary
description: Use when the user wants to understand a domain_stat branch at a glance. Typical requests include "summarize this domain_stat branch", "what is in this probe root", "show the case layout here", or "what does this domain_stat collection contain and what should happen next."
---

# Domain Stat Branch Summary

Use this skill for `domain_stat` inspection and summary while keeping its lightweight automation scope explicit.

## Preferred evidence

- normalized request object from `ccfep-request-normalizer` when the request starts from descriptive text
- `E:/ssh_scp/cluster_control/contracts/workstream_specs.json`
- `E:/ssh_scp/workstreams/domain_stat/contracts/path_families.json`
- `E:/ssh_scp/projects/workflow_reviews/domain_stat_workflow.md`
- remote `domain_stat` path listing
- probe or case root naming

## Contract-first boundary

- default to normalized request objects, workstream specs, path families, workflow review docs, and path evidence
- do not inspect Python implementation files unless contract or README evidence is insufficient
- prefer contracts and documented workflow notes over executor source
- if resource snapshots or locators are insufficient, emit `resource_lookup_needed`
- escalate as `implementation_lookup_needed` instead of reading code by default

## Layer and authoring rule

- never create a new script in this skill
- never modify executor implementation in this skill
- if script authoring seems required, hand off to `domain-stat-workstream-coder`

## When not to use

- do not use as if `domain_stat` already had full executor parity with `cb` or `03_train`
- do not use for direct scientific interpretation of final results beyond branch summary
- do not use for scheduler submission unless a separate manifest is created

## Minimal output schema

```json
{
  "branch_root": "",
  "chirality": "",
  "probe_type": "",
  "scope": "",
  "likely_outputs": [],
  "next_step": ""
}
```

## Ambiguity handling rule

- if chirality or probe type cannot be inferred from path naming, preserve `unknown`
- always keep the lightweight-workstream caveat explicit when executor parity is absent
