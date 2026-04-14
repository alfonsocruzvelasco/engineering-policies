# Linux Kernel AI Policy (April 2026)

**Source:** Linux kernel Documentation/process/coding-assistants.rst, April 2026

- AI-assisted contributions are permitted in the Linux kernel.
- New tag required: `Assisted-by:` (not `Signed-off-by:`) for transparency.
- Human submitter retains full legal and technical accountability for
  all AI-generated code, including bugs and security flaws.
- Torvalds' position: AI is a tool; banning tools is pointless; hold
  humans accountable for what they submit.
- Relevant for ML/CV work: kernel driver contributions (V4L2, CUDA
  modules, custom sensor drivers) follow this policy when submitted
  upstream.

**Policy impact:** None. Existing rules/security-policy.md verification
gates and rules/ai-workflow-policy.md accountability requirements already
align with this posture.
