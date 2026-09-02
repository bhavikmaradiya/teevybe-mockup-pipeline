# TeeVybe Mockup Pipeline

Portable Codex project for creating and validating staged TeeVybe T-shirt mockup batches.

## Included

- `AGENTS.md` — live, authoritative product and mockup rules.
- `.codex/skills/tee-mockup-pipeline/` — project-local skill, persistent-role routing, workflow gates, handoff contracts, Drive publishing rules, and verifier.
- `CLOUD_RUNBOOK.md` — cloud bootstrap, capability gate, authoritative-file index, and a ready-to-use prompt that delegates all behavior to the complete tracked rules and skill.
- `cloud-state/drive-intake-history.jsonl` — tracked cloud intake claim/delivery ledger; it stores processing metadata only, never source or generated images.
- `assets/size-charts/` — the three approved reusable 1080 × 1440 size-chart templates.
- `scripts/verify-delivery.sh` — final read-only delivery audit.

Generated mockups, run history, temporary state, credentials, and machine-specific Codex configuration are intentionally excluded.

## Use on another device

1. Clone this repository.
2. Open the cloned folder as the Codex project so the root `AGENTS.md` and project-local `.codex/skills/` directory are available together.
3. Reconnect image-generation, Google Drive, and any other required integrations on that device; credentials are never stored in this repository.
4. Attach the T-shirt reference image(s) and invoke `$tee-mockup-pipeline`, including the fit when known.
5. Keep generated delivery folders and `work/` local. They are ignored by Git so product outputs and identity history are not published accidentally.

If the Codex installation does not discover project-local skills, copy `.codex/skills/tee-mockup-pipeline/` to that user’s personal Codex skills directory while keeping `AGENTS.md` at the project root.

## Scheduled or cloud tasks

The repository makes the instructions, role contracts, scripts, and approved chart assets portable, but it does not grant cloud tools or credentials. A scheduled/cloud run must provide:

- repository access and a writable checkout;
- private-repository push permission when the cloud Drive intake ledger is enabled;
- the reference artwork in a cloud-accessible location (never a temporary path from another device);
- image-generation/editing capability;
- support for the coordinator, visual-director, and operations-QA role boundaries required by the skill;
- persistent output storage if completed mockups must survive the run; and
- separately configured credentials for optional Drive publishing.

Use a local scheduled task when the run depends on this Mac’s image-generation tools or local files. Use a cloud task only after confirming the cloud environment exposes the same required capabilities.

Use `CLOUD_RUNBOOK.md` to bootstrap a cloud run. It points the task to the complete tracked `AGENTS.md`, skill, and references without restating or shortening their rules.

## Safe updates

Update `AGENTS.md` for product-rule changes. Keep orchestration logic inside `.codex/skills/tee-mockup-pipeline/`, and do not copy the product rules into the skill. Commit both files together when a rule change also requires workflow changes.
