# Sync Policy

- Mirror stable README, contract, schema, template, and policy snapshots into skill-local `references/`.
- Do not mirror executor implementation files into this skill.
- Treat snapshots as resource-layer artifacts, not business objects.
- When a source file changes, refresh the snapshot metadata first; object-shape changes belong in `ccfep-io-contracts` or `ccfep-template-registry`.
- If a new locator or validator is needed, hand off to `ccfep-workstream-coder`.
