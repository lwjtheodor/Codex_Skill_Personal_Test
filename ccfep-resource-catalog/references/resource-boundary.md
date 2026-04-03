# Resource Boundary

## Resource layer

Owns:

- resource ids
- source paths
- snapshot paths
- freshness and drift
- read order
- preferred consumer hints

Does not own:

- object fields
- workflow policy
- capability semantics
- routing
- completion criteria

## Shared object layer

Owns:

- standardized object shapes
- field definitions
- failure and escalation states
- consumer order for object fields
