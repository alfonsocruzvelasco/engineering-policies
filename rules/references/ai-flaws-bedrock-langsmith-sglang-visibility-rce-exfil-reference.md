# Bedrock AgentCore Sandbox Egress + LangSmith URL/Token Safety + SGLang Safe Deserialization (Reference)

**Status:** Reference
**Last Updated:** 2026-03-20

## Source

This reference summarizes a Hacker News article describing multiple AI tooling security issues, including:

1. DNS-based command-and-control and data exfiltration via outbound DNS from “no network” sandbox execution (Amazon Bedrock AgentCore Code Interpreter).
2. Token theft / account takeover risk due to insufficient validation of a URL parameter controlling destination hosts (LangSmith `baseUrl`-style behavior).
3. Remote code execution risk from unsafe deserialization in brokered serving setups (SGLang ZeroMQ broker + pickle deserialization; plus risky replay utilities).

Source: [The Hacker News — AI Flaws in Amazon Bedrock, LangSmith, and SGLang Enable Data Exfiltration and RCE](https://thehackernews.com/2026/03/ai-flaws-in-amazon-bedrock-langsmith.html)

## Key takeaways (security-relevant)

* “No network access” assertions are not sufficient by themselves; egress isolation must be enforced and verified, including outbound DNS filtering.
* Observability/trace platforms can be attacked through unvalidated user-controlled URL parameters that cause tokens/bearer credentials to be sent to attacker-controlled origins.
* Brokered serving frameworks become remote code execution surfaces when they accept untrusted serialized inputs and perform unsafe deserialization (e.g., pickle.loads) or allow unauthenticated broker communication.

## How this repository’s policies map to the risks

* Use `rules/security-policy.md` sections **8.2–8.4** for agent runtime sandbox egress hardening, observability URL parameter safety, and safe deserialization/broker isolation.
* Keep “critical data” workloads in stronger isolation modes where available; treat weaker isolation modes as untrusted.
* Apply allowlists for domains/hosts when URL parameters can influence destinations.
* Ensure broker endpoints are not reachable from untrusted networks, and ensure serialized payloads are never deserialized unless provenance and safety guarantees are satisfied.
