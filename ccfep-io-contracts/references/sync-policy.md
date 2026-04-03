# IO Contract Sync Policy

- Keep object names stable once introduced.
- Add new fields additively when possible.
- Do not embed resource paths when an object field should only describe shape.
- Route resource discovery changes to `ccfep-resource-catalog`.
- Route implementation support changes to `ccfep-workstream-coder`.
