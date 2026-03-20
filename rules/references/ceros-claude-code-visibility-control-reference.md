# Ceros Trust Layer for Claude Code (Visibility + Runtime Policy Enforcement)

**Status:** Reference
**Last Updated:** 2026-03-20

## Source

This reference summarizes a Hacker News article describing how **Ceros** (Beyond Identity) sits alongside Claude Code to provide real-time visibility, runtime policy enforcement, and cryptographically auditable evidence for agent actions:

- [The Hacker News — How Ceros Gives Security Teams Visibility and Control in Claude Code](https://thehackernews.com/2026/03/how-ceros-gives-security-teams.html)

## What the article claims (security-relevant)

Claude Code can execute actions on a developer’s local machine (files, shell commands, external APIs, and MCP-connected tools) with the permissions of the user who launched it—before network-layer controls can observe the behavior.

The article describes Ceros providing:

- **Visibility:** Conversations/tool-call records showing what tool definitions were available and what was actually executed (arguments and outputs).
- **Runtime governance:** Policies evaluated before actions run, including **MCP server allowlisting** and **tool-level policies** (e.g., block shell access or restrict filesystem reads to approved areas).
- **Device posture gating:** Requiring conditions such as disk encryption enabled and endpoint protection running, with continuous re-evaluation.
- **Tamper-evident audit evidence:** Append-only activity logs with cryptographic signing including user/device context and execution ancestry.
- **Managed MCP deployment:** Admins can push approved MCP servers to developers to standardize governance.

## How it maps to this repository’s policy controls

This aligns directly with repo expectations for:

- **Runtime policy enforcement** for agent tool/MCP activity (policy decision happens before execution).
- **Allowlisting** of MCP servers and sensitive tool capabilities.
- **Tamper-proof / cryptographically signed audit trails** for agent actions.
- **Device posture requirements** gating autonomous agent sessions.
