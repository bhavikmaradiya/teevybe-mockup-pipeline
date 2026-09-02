---
name: tee-mockup-pipeline
description: Orchestrate and validate staged TeeVybe T-shirt mockup batches governed by the current workspace AGENTS.md. Use for creating, regenerating, correcting, auditing, or delivering these mockup batches; do not use for unrelated image or apparel work.
---

# TeeVybe Mockup Pipeline

Use this skill only when the current workspace contains an `AGENTS.md` whose top heading is `# T-shirt Mockup Project Rules`, or when the user explicitly invokes `$tee-mockup-pipeline` and supplies that rule file. The workspace `AGENTS.md` is the live and sole source of product rules. Never copy it into this skill, edit it, replace it, or rely on remembered excerpts.

## Required startup

1. Locate and read the complete applicable `AGENTS.md` before any batch action.
2. Record its absolute path and SHA-256 in batch state outside the delivery folder.
3. Read [references/workflow.md](references/workflow.md), [references/agent-contracts.md](references/agent-contracts.md), and [references/model-routing.md](references/model-routing.md).
4. When a cloud or scheduled run is configured to discover source artwork from Google Drive, read [references/drive-intake.md](references/drive-intake.md) before listing or downloading intake files. Treat intake as read-only and require its separate Drive-backed durable claim ledger before generation.
5. When Drive mirroring is configured for the batch, also read [references/drive-publish.md](references/drive-publish.md) before the publish stage.
6. Inspect every supplied reference individually at original quality. Never build a collage, contact sheet, or minimap.
7. Create the batch lock and receive coordinator approval before image generation.

Reread the full rule file at every stage gate named in `AGENTS.md`. Before each gate, compare its current SHA-256 with the stored value. If it changed, pause, reread it fully, update the hash and affected lock decisions, and revalidate accepted work. Never revert user changes.

## Agent topology

Keep one persistent agent per role for the whole batch; never spawn an agent per image.

- Coordinator: `gpt-5.6-terra`, medium reasoning. Owns stage order, rule/hash checks, handoffs, state, and delivery approval.
- Visual Director: `gpt-5.6-sol`, medium reasoning. Owns image/reference analysis, generation prompts, image-generation tool use, and every visual acceptance decision.
- Operations QA: `gpt-5.6-luna`, low reasoning. Owns deterministic folders, names, dimensions, formats, checksums, permitted shared-file copies, mechanical reports, and approved post-delivery Drive mirroring.

For local/project runs, if the invoking agent cannot run as Terra Medium, it must spawn a persistent Terra Medium coordinator and act as a thin dispatcher. The dispatcher may execute tool calls requested by the coordinator but must not bypass coordinator gates.

For a web/cloud Scheduled task that exposes Sol but cannot spawn persistent Terra/Luna role agents, use the cloud-only Sol fallback defined in [references/model-routing.md](references/model-routing.md). One Sol session may execute the Coordinator, Visual Director, and Operations QA as sequential logical roles, but it must keep their decisions and reports separate, run all deterministic mechanical checks, and may not use a visual conclusion as mechanical proof or vice versa. Disclose this fallback once at startup. Missing Terra/Luna spawning alone is not a capability-gate failure in this mode. This exception does not apply to local/project runs and does not relax any `AGENTS.md` product rule, stage gate, retry control, artwork check, or final audit.

## Hard boundaries

- Only the Visual Director may accept artwork fidelity, side placement, identity, fit, environment continuity, pose, framing, fabric-detail correctness, logo appearance, or overall visual quality.
- Operations QA must not generate images, interpret artwork, accept identities, draw a size chart, alter T-shirt artwork, or choose logo placement. For `07.jpg`, it may only byte-for-byte copy the approved profile-matched final template and report hashes and dimensions.
- Size-chart handling must follow the current `AGENTS.md` reusable-template workflow. Never generate, redraw, lay out, crop, resize, stretch, logo-overlay, re-encode, or otherwise customize a final template during a product batch. A user-authorized template-library refresh is the only exception; the Visual Director must validate every regenerated 1080 x 1440 template before it replaces the library source.
- Deterministic compositing must never place or alter T-shirt artwork. It may perform final JPEG export for mockups when the rule file permits it; it must not alter a final `07.jpg` template.
- For `04.jpg`, separate generation intent from validation tolerance. The Visual Director must prompt and compose the image from approximately the chin and lower lip downward, never from the top of the head or with the eyes/nose/forehead/full head in the requested frame. It must also apply an artwork-first framing gate: preserve the artwork's true garment scale and placement, but place the camera close enough that the complete artwork fills the composition at the largest practical scale with only a narrow contextual fabric margin. Reject a technically complete image when excess side fabric, sleeves, garment silhouette, or background makes it T-shirt-centric instead of design-centric. After generation, slight non-obstructive visibility of the chin, lips, nape, or a narrow lower-face edge remains an acceptance tolerance and must not be elevated into a critical failure when the artwork is complete, sharp, readable, centered, unobstructed, and clearly primary. A later audit must not reverse an accepted `04.jpg` solely for that harmless detail.
- Validate native source ratio immediately after every generation. If an otherwise visually acceptable result is only a near-3:4 renderer output, preserve it through one targeted generative reframe onto exact 3:4 rather than rerolling identity, artwork, styling, or scene. Reinspect the reframed pixels; never treat prompt wording or a requested ratio as proof, and never repair the mismatch by cropping, stretching, padding, or deterministic artwork compositing.
- Before locking an environment, the Visual Director must record how its dominant hue and luminance separate the actual T-shirt from the background. A dark T-shirt against a predominantly dark or night environment is invalid unless the planned lighting and a lighter/contrasting background zone clearly separate the garment silhouette; optical blur alone is not contrast.
- Do not prelock an exact model identity, face, hairstyle, body build, accessory styling, or exact bottom wear before that gender's first `01.jpg` candidate. Preflight may record only broad rule/user eligibility constraints. The first visually accepted `01.jpg` becomes the exact identity and styling anchor. Do not reject an otherwise valid first `01.jpg` because acceptable hair, facial details, accessories, or styling differ from a speculative pre-generation description.
- Do not lock an exact bottom-wear style or color before that gender's `01.jpg`. Preflight locks only a requirement for clear T-shirt contrast and user constraints. Once `01.jpg` is accepted, its actual bottom-wear style/color/wash/silhouette becomes the continuity lock. An otherwise valid `01.jpg` must not be regenerated merely for differing from a speculative pre-generation bottom-wear choice.
- Do not lower source quality or generate extra candidates merely to save or spend credits.
- Do not deliver while either the visual audit or mechanical audit is failing, missing, stale, or based on a different `AGENTS.md` hash.
- When a Drive destination is configured, do not mark the batch fully delivered until the approved local hierarchy has been mirrored and verified under that destination. Drive publishing must never overwrite, delete, move, share, or alter an existing Drive item without a new explicit user instruction.

## Completion

Use `scripts/verify-delivery.sh` for the final read-only mechanical audit. The Coordinator must then compare the visual and mechanical reports, reread `AGENTS.md`, verify the hash once more, and approve local delivery explicitly. When Drive mirroring is configured, Operations QA must then follow [references/drive-publish.md](references/drive-publish.md) before the Coordinator marks the batch fully delivered. Store working state under `work/mockup-runs/<batch-slug>/`, and maintain cross-batch identity/environment history at `work/mockup-runs/batch-history.jsonl`; keep the delivery folder limited to the structure required by `AGENTS.md`.
