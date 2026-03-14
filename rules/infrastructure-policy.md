# Infrastructure Policy

**Status:** Authoritative
**Last updated:** 2026-03-12
**Purpose:** Infrastructure standards for Docker/Podman, Kubernetes, and Kafka

---

## Docker/Podman/Kubernetes/Kafka

Below is a professional-team rule set for **Docker / Kubernetes / Podman / Kafka**, written as enforceable policy suitable for real production teams.

## 1) Core principles

1. **Reproducibility over convenience.** Images, manifests, and configs must build and deploy identically in CI and production.
2. **Immutability by default.** Containers are immutable artifacts; configuration and data are external.
3. **Declarative everything.** Desired state is described in version control, not applied manually.
4. **Security is continuous.** Least privilege, image scanning, and network controls are baseline, not add-ons.
5. **Observability is mandatory.** Every service is measurable, debuggable, and traceable.

## 2) Containers: Docker & Podman fundamentals

6. **One process per container** (one responsibility).
7. **Containers are stateless.** Persistent data lives in volumes or external services.
8. **No SSH into containers** as an operational strategy. Debug via logs, metrics, and ephemeral debug containers.
9. **Podman vs Docker is a runtime choice**, not a design change:

   * OCI-compliant images only
   * No Docker-specific hacks if Podman is supported.
10. **Rootless containers preferred** where possible (especially with Podman).

## 3) Dockerfile authoring rules

11. **Minimal base images**:

    * distroless / slim / alpine only when compatible
    * pin base image versions (no `latest`).
12. **Multi-stage builds** are mandatory for compiled languages.
13. **Explicit COPY lists.** No `COPY . .` without `.dockerignore`.
14. **No secrets in images**:

    * no `.env`
    * no tokens
    * no private keys.
15. **Non-root user** inside containers unless there is a documented exception.
16. **Deterministic builds**:

    * pinned package versions where feasible
    * reproducible dependency installs.
17. **Entrypoint vs CMD are intentional**:

    * ENTRYPOINT defines the executable
    * CMD defines defaults.
18. **Healthcheck defined** for long-running services.

## 4) Image management and registries

19. **Images are versioned and immutable** once pushed.
20. **Tags have meaning**:

    * semantic version or git SHA
    * never rely on mutable tags.
21. **Images are built in CI**, not on developer machines.
22. **Image scanning is mandatory** (CVEs, base image issues).
23. **Private registries are authenticated via CI secrets**, not developer machines.

## 5) Kubernetes fundamentals

24. **Kubernetes manifests are declarative** and stored in Git.
25. **No manual `kubectl apply` in production** outside break-glass procedures.
26. **Namespaces reflect environments or domains** (not everything in `default`).
27. **Everything runs as a Pod abstraction**, never directly as containers.
28. **Resource requests and limits are mandatory** for all workloads.
29. **Liveness and readiness probes are required** for long-running services.
30. **Graceful shutdown is implemented** (SIGTERM handling).

## 6) Kubernetes configuration discipline

31. **ConfigMaps for configuration**, **Secrets for secrets**.
32. **Secrets are not stored in Git in plaintext**.
33. **Environment variables vs files**: choose one pattern per service and standardize.
34. **No hardcoded service URLs**; use service discovery.
35. **Labels and annotations are consistent** (app, version, environment, owner).

## 7) Kubernetes workload rules

36. **Deployments for stateless services.**
37. **StatefulSets for stateful workloads** (databases, Kafka brokers).
38. **Jobs/CronJobs for batch work**, not Deployments.
39. **Horizontal Pod Autoscaler (HPA)** is configured where traffic varies.
40. **No single-replica production services** unless explicitly justified.

### 7.1) Kubernetes v1.35 (Timbernetes) and ML/CV workloads

Kubernetes v1.35 strengthens its role as the operational substrate for AI/ML workloads. Plan Helm charts and Job specs against the new surfaces below so migration cost is low when features graduate.

**Features relevant to ML/CV:**

| Feature | Status | ML/CV significance |
|--------|--------|---------------------|
| **Workload API + gang scheduling** | Alpha | Distributed training (PyTorch DDP, JAX, Ray) requires all workers to launch simultaneously; partial deployment holds GPU allocation without progress. Native gang scheduling in kube-scheduler removes the need for Volcano/Yunikorn/custom webhooks for this guarantee. Write Job specs against the Workload API surface now for portability when it reaches beta/stable (v1.36–1.37). |
| **In-place Pod resource resize** | GA | CPU/memory updates without container restart. Critical for inference: right-size vLLM/Triton pods after profiling without rollout or cold model reload. Makes Vertical Pod Autoscaler (VPA) practical for inference. |
| **Dynamic Resource Allocation (DRA)** | Alpha enhancements | Consumable capacity, partitionable devices, device taints. Express multi-GPU topologies (e.g. MIG slices, device taints) at cluster level instead of node selectors and custom labels. Use for multi-GPU CV pipelines and structured accelerator claims. |
| **Opportunistic batching** | Beta (on by default) | Scheduler reuses feasibility calculations for identical Pods (same requests, affinities, images). Faster startup for large distributed jobs (e.g. 64 worker pods); less wall-clock time between submit and GPU utilization. |
| **Pod certificates (workload identity)** | Beta (on by default) | Native workload identity for zero-trust and mTLS; reduces reliance on external controllers or sidecars. |

**Breaking changes — audit before upgrading to v1.35:**

- **cgroup v1 removal:** kubelet will not start on nodes that do not support cgroup v2. Audit ML nodes (e.g. CentOS 7, older Ubuntu LTS); upgrade or replace nodes that still rely on cgroup v1.
- **kube-proxy IPVS deprecation (nftables):** If service load balancing across inference replicas uses IPVS kube-proxy, plan migration to nftables. Intentional node fleet audit required before upgrade.

**Policy:** For new ML/CV Kubernetes workloads (distributed training Jobs, inference Deployments), design against the Workload API and in-place resize semantics so that when gang scheduling and DRA reach stable, no spec rewrites are required. Do not rely on cgroup v1 or IPVS kube-proxy on nodes targeting v1.35+ without a documented migration plan.

## 8) Networking and security

41. **NetworkPolicies are defined**; default-deny where feasible.
42. **Service-to-service traffic is explicit**, not implicit.
43. **Ingress rules are minimal and audited.**
44. **TLS everywhere** (internal and external) where feasible.
45. **RBAC is least-privilege**:

    * service accounts per workload
    * no cluster-admin defaults.
46. **No privileged containers** unless formally approved.

### 8.1) Ingress NGINX deprecation and migration (CRITICAL)

**⚠️ DEPRECATION NOTICE: Kubernetes Ingress NGINX is being retired in March 2026**

**Status:** Kubernetes Steering and Security Response Committees announced retirement effective March 2026 ([source](https://thenewstack.io/kubernetes-to-retire-ingress-nginx/)).

**Critical Security Concerns:**
* Ingress NGINX has been prone to security vulnerabilities, including "IngressNightmare" (March 2025) with CVSS 9.8 critical vulnerabilities allowing unauthenticated remote code execution
* Only 1-2 maintainers supporting a tool used by 50% of Kubernetes users
* **No more bug fixes, security patches, or updates after March 2026**
* Existing deployments will continue to work but will be vulnerable to unpatched exploits

**Migration Requirements:**
* **MUST migrate away from Ingress NGINX before March 2026**
* **No drop-in replacement exists** — migration requires planning and testing
* **Gateway API is the modern, recommended alternative** (Kubernetes-native, more secure, better designed)
* Alternative: Chainguard EmeritOSS program (commercial support option, but not recommended for new deployments)

**Migration Strategy:**
1. **Immediate action (before March 2026):**
   - Audit all clusters for Ingress NGINX usage
   - Document all Ingress resources and configurations
   - Plan migration timeline (allow 2-3 months for testing and rollout)

2. **Gateway API migration path:**
   - Use Gateway API (Kubernetes SIG Network standard)
   - Gateway API provides better security, extensibility, and standardization
   - Supports HTTPRoute, TCPRoute, UDPRoute, TLSRoute resources
   - Better separation of concerns (Gateway vs Route resources)

3. **Testing requirements:**
   - Test Gateway API implementation in non-production environments first
   - Validate TLS termination, routing rules, and load balancing behavior
   - Ensure observability and monitoring tools work with Gateway API
   - Test rollback procedures

4. **Production migration:**
   - Migrate incrementally (service by service or namespace by namespace)
   - Maintain both Ingress NGINX and Gateway API during transition
   - Monitor for routing issues, performance degradation, or errors
   - Complete migration before March 2026 retirement date

**Prohibited:**
* ❌ **DO NOT** deploy new Ingress NGINX installations
* ❌ **DO NOT** rely on Ingress NGINX after March 2026 without commercial support (Chainguard EmeritOSS)
* ❌ **DO NOT** assume Ingress NGINX will continue to receive security patches

**Required:**
* ✅ **MUST** use Gateway API for all new ingress configurations
* ✅ **MUST** migrate existing Ingress NGINX deployments before March 2026
* ✅ **MUST** document migration plan and timeline
* ✅ **MUST** test Gateway API thoroughly before production deployment

**Reference:**
* [Kubernetes Ingress NGINX Retirement Announcement](https://thenewstack.io/kubernetes-to-retire-ingress-nginx/)
* [Gateway API Documentation](https://gateway-api.sigs.k8s.io/)
* [Chainguard EmeritOSS (commercial support option)](https://www.chainguard.dev/unchained/chainguard-announces-emeritoss-program)

## 9) Podman-specific considerations

47. **OCI compatibility is required** (images must run under Docker and Podman).
48. **Rootless execution tested** in CI or staging.
49. **Systemd integration (podman generate systemd)** is used only for non-Kubernetes deployments.
50. **Do not rely on Docker socket semantics** (`/var/run/docker.sock`).

## 10) Kafka fundamentals

51. **Kafka is treated as critical infrastructure**, not a side component.
52. **Topics are versioned and managed declaratively** (IaC or admin tooling).
53. **Partitions, replication factor, and retention are explicit** and documented.
54. **No auto-topic creation in production.**
55. **Producers and consumers define ownership** of topics clearly.

## 11) Kafka producers

56. **Keys are intentional** (ordering and partitioning matter).
57. **Idempotent producers enabled** when supported.
58. **Retries and timeouts are configured explicitly.**
59. **No fire-and-forget sends** for critical data.
60. **Schemas are versioned** (Avro/Protobuf/JSON Schema) and backward-compatible.

## 12) Kafka consumers

61. **Consumer groups are explicit and stable.**
62. **Offset commit strategy is deliberate** (auto vs manual).
63. **At-least-once vs exactly-once semantics are documented.**
64. **Poison messages are handled** (DLQ, retries, backoff).
65. **Consumers are idempotent** where possible.

## 13) Kafka operations and reliability

66. **Monitoring is mandatory**:

    * broker health
    * consumer lag
    * disk usage
67. **Retention and compaction policies are reviewed regularly.**
68. **No schema breaking changes without coordination.**
69. **Backpressure and burst handling are tested.**
70. **Kafka upgrades are planned and tested** (never ad hoc).

## 14) Observability

71. **Structured logs** (JSON) for containers.
72. **Metrics exposed** (Prometheus-compatible where applicable).
73. **Tracing enabled** for request and message flows.
74. **Correlation IDs propagate** across HTTP, gRPC, and Kafka.
75. **Dashboards exist for critical services** before incidents happen.

## 15) CI/CD expectations

76. **CI builds images, runs tests, scans images.**
77. **CD deploys via GitOps or controlled pipelines**, not manual pushes.
78. **Rollback strategy is defined and tested.**
79. **Config drift detection is enabled.**
80. **No production deploys without passing CI gates.**

## 16) Common anti-patterns to ban

81. `latest` image tags in production.
82. Containers running as root without justification.
83. Manual edits to live Kubernetes resources.
84. Secrets baked into images or committed to Git.
85. Kafka topics created ad hoc by applications.
86. Consumers without lag monitoring.
87. Missing resource limits leading to noisy-neighbor failures.
88. **Using Ingress NGINX (deprecated, retiring March 2026)** — use Gateway API instead.
89. **Targeting Kubernetes v1.35+ with cgroup v1 or IPVS kube-proxy** without a migration plan — audit nodes and migrate to cgroup v2 and nftables before upgrade.

## 17) Minimal "gold standard" checklist

88. Dockerfiles are multi-stage, non-root, scanned.
89. Images are built in CI and deployed immutably.
90. Kubernetes workloads have requests/limits, probes, and RBAC.
91. Kafka topics and schemas are versioned and monitored.
92. Logs, metrics, and traces are available for every service.
93. Rollbacks are fast and documented.
94. **Ingress uses Gateway API (not deprecated Ingress NGINX)** — migration completed before March 2026.
95. **Kubernetes v1.35+ (ML/CV):** Node fleet uses cgroup v2 and nftables (not cgroup v1 / IPVS); distributed training and inference specs align with Workload API and in-place resize where applicable.


---
