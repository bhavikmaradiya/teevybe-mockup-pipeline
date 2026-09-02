# TeeVybe Cloud Runbook

This file tells a cloud or scheduled Codex task how to operate the TeeVybe mockup pipeline. It is an execution guide, not a second product-rule file.

`AGENTS.md` at the repository root is always the live and sole source of product rules. The cloud task must read it in full at startup and at every stage gate it defines. If this runbook, a remembered instruction, or a prompt conflicts with `AGENTS.md`, `AGENTS.md` wins.

## What the cloud environment must provide

Before spending any image-generation credits, confirm all of the following:

- A checkout of this repository with write access.
- The root `AGENTS.md`, project-local `.codex/skills/tee-mockup-pipeline/`, approved `assets/size-charts/`, and verification scripts.
- Image generation and generative image-editing capability that can use the supplied references.
- Support for the persistent Coordinator, Visual Director, and Operations QA roles described by the skill. If model overrides are unavailable, preserve the same role boundaries and record the fallback before continuing.
- Reference images available from durable cloud-accessible paths, attachments, or object storage. A `/tmp` path or Downloads path from another device is not accessible to a cloud run.
- Persistent artifact storage for completed JPEGs and run state if the checkout is temporary.
- Separately configured credentials and permissions for optional Google Drive publishing. Never store credentials in this repository.

If any required capability is missing, stop before generation and report the exact missing capability. Repository access alone does not grant image generation, browser, Drive, GitHub, or storage permissions.

## Input contract

Each scheduled or cloud invocation should provide:

```yaml
fit: "oversized fit | regular fit | polo fit"
front_reference: "durable cloud path or attachment identifier, or blank"
back_reference: "durable cloud path or attachment identifier, or blank"
artwork_side_when_single_reference: "front | back"
design_name: "short human-readable name"
tshirt_color: "visible garment color"
user_environment_direction: "optional; authoritative when supplied"
material_callout: "truthful material wording for 06.jpg"
drive_destination: "optional grounded folder identifier"
```

When a product-critical value is genuinely ambiguous after inspecting the references, pause and ask the user. Do not guess the fit, artwork side, or material claim.

## Required startup sequence

1. Read the complete root `AGENTS.md` and compute its SHA-256.
2. Read the complete pipeline skill and its runtime references:
   - `.codex/skills/tee-mockup-pipeline/SKILL.md`
   - `.codex/skills/tee-mockup-pipeline/references/workflow.md`
   - `.codex/skills/tee-mockup-pipeline/references/agent-contracts.md`
   - `.codex/skills/tee-mockup-pipeline/references/model-routing.md`
   - `.codex/skills/tee-mockup-pipeline/references/drive-publish.md` when Drive publishing is requested
3. Inspect every supplied reference separately at original quality. Never use a collage, contact sheet, or minimap.
4. Load `work/mockup-runs/batch-history.jsonl`. If unavailable, reconstruct the required non-reuse context from existing delivered anchors as directed by the workflow.
5. Create `work/mockup-runs/<batch-slug>/batch-lock.yaml` using the contract in `agent-contracts.md`.
6. Complete and approve the pre-generation lock. Before either gender's first `01.jpg`, keep exact identity, hairstyle, build, accessories, styling, and exact bottom wear pending. Lock only broad eligibility, novelty direction, user requirements, bottom-wear contrast, artwork roles, fit, environment family and contrast plan, output name, and shared-asset decisions.

No mockup generation may begin until this startup gate passes.

## Generation decision process

Use one persistent agent for each role throughout the batch:

- Coordinator: owns rule rereads/hashes, stage order, state, retry stops, and final approval.
- Visual Director: owns reference interpretation, prompts, image generation, and every visual decision.
- Operations QA: owns paths, dimensions, hashes, permitted copies, exports, and mechanical verification.

Run one gender at a time in this gated order:

1. Generate `01.jpg` as the first candidate without preselecting an exact person or styling. Validate artwork, side, oversized/regular/polo silhouette, model eligibility and novelty, environment contrast, framing, and contrasting bottom wear.
2. Only after `01.jpg` is visually accepted, record the actual person, hair, body build, visible accessories, styling, and bottom-wear details as the exact same-gender continuity anchor.
3. Generate `03.jpg` as the different-angle identity test when practical. Continue only after it visibly matches the exact accepted person and styling.
4. Generate the remaining images individually, validating after every candidate. Never generate the whole gender set blindly.
5. For `04.jpg`, compose from approximately the chin and lower lip downward. Make the complete artwork the largest practical subject with only a narrow fabric margin. The lower-face allowance is validation tolerance only; it is not permission to request a head-first or T-shirt-centric composition.
6. For every generated source, mechanically check that the native width:height ratio is exactly `3:4` before visual acceptance. If an otherwise accepted source is only a near miss, use one targeted generative reframe that preserves the accepted identity, artwork, garment, styling, and environment. Never crop, stretch, or pad to repair the ratio.
7. For `06.jpg`, reread the full rules and follow either the gender-specific model-worn path or the allowed shared model-free path. Validate the real plain-fabric magnifier source, truthful callouts, complete artwork, and safe layout.
8. For `07.jpg`, copy the fit-matched approved template byte-for-byte into both gender folders. Never regenerate, edit, resize, re-encode, or brand it.

After each generation, validate artwork fidelity and side, exact identity, fit, environment continuity and contrast, pose, framing, exact ratio, and that image's special requirements. Save only accepted candidates.

If the same critical failure repeats twice, pause that stage and strengthen the relevant lock or identity anchor. Regenerate only the failed numbered image unless the accepted anchor itself is invalid.

## Output, audit, and persistence

- Keep transient state in `work/mockup-runs/<batch-slug>/`, outside the delivery folder.
- Create the delivery hierarchy and filenames exactly as required by `AGENTS.md`.
- Export every product image at exactly 1080 × 1440 as a high-quality JPEG without stretching.
- Run `scripts/verify-delivery.sh <batch-directory>` and add `--shared-06` only when that exception was selected.
- Have the Visual Director inspect every final JPEG individually at delivery size.
- Have the Coordinator reread `AGENTS.md`, recheck its hash, reconcile the current visual and mechanical reports, and approve delivery explicitly.
- Append cross-batch history only after final approval. Never rewrite earlier history to hide identity or environment reuse.
- If the runner is ephemeral, upload the approved delivery folder and required run records to durable artifact storage before the task exits.
- When Drive publishing is requested, perform it only after local delivery approval and follow `drive-publish.md`. Stop on a collision or partial upload; do not overwrite or clean up automatically.

Never claim completion from prompts, logs, or filenames alone. Completion requires inspected pixels plus a passing mechanical audit.

## Ready-to-use cloud or scheduled task prompt

Replace every value in angle brackets before scheduling:

```text
Run the TeeVybe mockup pipeline from this repository for <DESIGN NAME>.

Inputs:
- Fit: <FIT>
- Front reference: <DURABLE CLOUD PATH OR ATTACHMENT, OR BLANK>
- Back reference: <DURABLE CLOUD PATH OR ATTACHMENT, OR BLANK>
- If there is one reference, intended artwork side: <FRONT OR BACK>
- T-shirt color: <COLOR>
- Environment direction: <OPTIONAL USER DIRECTION>
- Truthful material callout for 06.jpg: <MATERIAL>
- Optional Drive destination: <GROUNDED FOLDER ID OR NONE>

Before any image generation, read CLOUD_RUNBOOK.md, the complete root AGENTS.md, the complete project-local tee-mockup-pipeline skill, and all runtime references required by them. Treat AGENTS.md as the sole live product-rule source. Confirm the cloud capability gate, inspect each input independently, compute and store the AGENTS.md SHA-256, load cross-batch history, create the batch lock, and obtain the required role approvals.

Use persistent Coordinator, Visual Director, and Operations QA roles. Follow the gated 01-anchor and identity-test sequence for each gender; lock no exact identity, hairstyle, accessories, body build, or bottom-wear details before that gender's first 01.jpg is generated and visually accepted. Enforce artwork fidelity, correct side placement, fit, model identity, environment/theme relevance, obvious T-shirt/background contrast, exact native 3:4 generation, artwork-first 04 framing from around the chin/lower lip downward, the applicable 06 workflow, and byte-identical approved 07 templates.

Generate or correct only one required candidate at a time. Stop after two repeated critical failures and strengthen the relevant lock before another generation. Deliver only after the file-by-file visual audit and scripts/verify-delivery.sh both pass against the current AGENTS.md hash. Persist the approved delivery and required run records before the cloud task exits. If a required tool, reference, credential, role, or persistent storage location is unavailable, stop before spending generation credits and report the exact blocker.
```

## Updating the pipeline

- Change product rules only in `AGENTS.md`.
- Change orchestration behavior only in `.codex/skills/tee-mockup-pipeline/` and its references.
- Update this runbook only when cloud startup, input, capability, persistence, or scheduling guidance changes.
- Commit rule and orchestration changes together when they depend on each other.
