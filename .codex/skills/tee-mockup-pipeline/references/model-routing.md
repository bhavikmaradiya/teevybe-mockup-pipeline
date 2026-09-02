# Model Routing

Use persistent role agents and route by decision type. Model names and reasoning levels are requested overrides; if a runtime does not expose an override, report the fallback before continuing and preserve the boundaries below.

## Web/cloud Scheduled-task Sol fallback

When a web/cloud Scheduled task exposes a capable Sol model and the required image/files/connectors but cannot spawn persistent Terra or Luna agents, do not stop merely because multi-agent spawning or those model routes are unavailable. Disclose the fallback once and use the single Sol session to execute three sequential logical roles:

1. **Coordinator phase:** reread and hash the current rules, maintain the batch lock, enforce stage order and stopping conditions, and authorize the next phase.
2. **Visual Director phase:** inspect original and generated pixels and make every visual decision. Record a Visual Director stage result before leaving the phase.
3. **Operations QA phase:** perform only deterministic filesystem, filename, MIME, dimensions, checksum, permitted file-copy, ledger, and publishing checks. For cloud `07.jpg`, apply the native Drive-copy evidence exception in `cloud-size-charts.md`. Record a separate Operations QA result based on observed tool output, never on the prior visual conclusion.

The same Sol session may change logical roles only at an explicit phase boundary. It must not merge the visual and mechanical reports, let one report stand in for the other, skip the final file-by-file visual audit, or approve delivery while either report fails or is stale. Use available deterministic tools/scripts for Operations QA. This cloud-only fallback preserves role boundaries but does not claim independent-agent review. It is not permitted for a local/project run where the normal persistent topology is available.

## Coordinator

- Model: `gpt-5.6-terra`
- Reasoning: `medium`
- Owns: rule rereads and hashes, batch-lock approval, stage order, specialist handoffs, stale-state detection, retry stopping conditions, and final delivery decision.
- Must not: overrule a failed visual audit, perform image generation merely because a specialist is unavailable, or approve delivery without both current audits.

For local/project runs, if the parent task is not Terra Medium, create one persistent Terra Medium coordinator. The parent remains a thin dispatcher for spawning, messaging, waiting, and executing approved tool calls. Do not create a fresh coordinator at each stage. For eligible web/cloud Scheduled tasks, use the disclosed Sol fallback above when persistent spawning is unavailable.

## Visual Director

- Model: `gpt-5.6-sol`
- Reasoning: `medium`
- Owns: original-image analysis, front/back and fit interpretation, visual lock fields, image-generation prompts and calls, model identity, styling, artwork fidelity, fit silhouette, scene continuity, composition, fabric detail, selected reusable-template visual validation, logo appearance where applicable, and file-by-file visual audit.
- Must not: mechanically copy shared files, draw charts with code, use deterministic T-shirt artwork compositing, or delegate visual acceptance to Operations QA.

The dedicated image-generation tool renders pixels. Sol Medium supplies the visual reasoning, prompt constraints, referenced images, and acceptance decisions.

## Operations QA

- Model: `gpt-5.6-luna`
- Reasoning: `low`
- Owns: directory creation, numeric filenames, file counts, JPEG/PNG MIME checks, exact dimensions, SHA-256, permitted byte-identical copy of accepted shared assets and local selected-template `07.jpg` exports, the cloud-only native Drive-copy procedure in `cloud-size-charts.md`, manifest/history updates, final JPEG export, running the read-only delivery verifier, and mirroring an approved final batch to a configured Google Drive root.
- Must not: generate or edit mockup imagery or T-shirt artwork, infer design sides or fit, judge identity or artwork quality, choose a background, choose or alter logo placement, create a size chart, or claim visual acceptance. For local/project `07.jpg`, it may only copy and hash the approved final template. For cloud `07.jpg`, it may only natively copy the exact approved Drive source and verify destination readback. It must never add a logo, crop, resize, stretch, re-encode, customize, download, reconstruct, or upload the chart. For Drive it must only create the approved new hierarchy, upload approved `01.jpg` through `06.jpg` assets, and perform the authorized `07.jpg` copies; it must not overwrite, duplicate, rename, move, delete, or modify sharing, and it must stop on a collision or partial failure.

## Escalation

- Mechanical uncertainty stays with Operations QA and escalates to the Coordinator.
- Any question requiring looking at image content goes to the Visual Director.
- Product-rule ambiguity goes to the Coordinator, who rereads `AGENTS.md` and asks the user only when the answer is not discoverable.
- A specialist failure does not authorize another role to assume its prohibited work.
- Reuse existing role agents via follow-up messages. Spawn a replacement only when an agent is unavailable or its context is irrecoverably stale, and provide the complete current lock and hash to the replacement.
