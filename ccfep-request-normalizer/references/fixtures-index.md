# Fixtures Index

Use these fixtures to test downstream consumers of normalized CCFEP request objects.

## Positive Fixtures

- [inspection-request.json](./fixtures/inspection-request.json)
  - Pure inspection request
- [case-filter-request.json](./fixtures/case-filter-request.json)
  - Request that requires filtering cases from markers and policy
- [manifest-generation-request.json](./fixtures/manifest-generation-request.json)
  - Request that should flow into manifest drafting
- [handoff-decision-request.json](./fixtures/handoff-decision-request.json)
  - Request that should flow into handoff planning
- [high-ambiguity-request.json](./fixtures/high-ambiguity-request.json)
  - Request with strong ambiguity that should stay explicit

## Negative Fixtures

- [underspecified-request.json](./fixtures/underspecified-request.json)
  - Too few markers to continue safely
- [conflicting-request.json](./fixtures/conflicting-request.json)
  - Mutually inconsistent markers or downstream intent

## Fixture Use

Use positive fixtures to check:

- path normalization
- routing behavior
- resolved input consumption
- manifest or handoff readiness

Use negative fixtures to check:

- explicit failure states
- fallback to protocol, report, or review
- refusal to silently invent missing meaning
