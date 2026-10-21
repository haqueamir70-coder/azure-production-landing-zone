# Architecture Decision Records — Azure Landing Zone

## ADR-001: Terraform for repeatable infrastructure
**Decision:** Define the foundation as code and review changes through version control.

**Rationale:** Changes can be diffed, reviewed, validated, and reproduced.

**Consequences:** Terraform state is sensitive operational data. Use a secured remote backend for team use; do not commit state or credentials.

## ADR-002: Separate application and private subnets
**Decision:** Use distinct subnet boundaries and associated network security groups.

**Rationale:** This creates a place to express different traffic requirements.

**Consequences:** Subnet separation alone is not a complete security boundary. Validate effective routes, NSG rules, private endpoints, DNS, and workload exposure.

## ADR-003: Explicit identity and secret management
**Decision:** Prefer managed identities and Azure Key Vault RBAC for supported workloads.

**Rationale:** Reduce long-lived credentials and centralize access control.

**Consequences:** Validate role assignments, data-plane permissions, network reachability, soft delete, purge protection, and diagnostic logging.

## ADR-004: Safe change promotion
**Decision:** Separate validation and plan review from apply.

**Rationale:** Formatting, validation, and static scans can catch some issues before deployment; a reviewed plan helps identify unintended changes.

**Consequences:** CI success is not equivalent to production readiness. Apply should use a least-privilege identity and approval controls appropriate to the environment.

## Validation status
These decisions describe intended design principles. Check current Terraform configuration and run validation before claiming each control is fully implemented.
