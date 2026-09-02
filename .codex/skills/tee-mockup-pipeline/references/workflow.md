# Runtime Workflow

This reference defines orchestration, not product requirements. At every conflict or omission, the current workspace `AGENTS.md` wins.

## 1. Preflight and batch lock

The Coordinator must:

1. Read the full `AGENTS.md`, store its absolute path and SHA-256, and confirm the activation guard.
2. Inspect user instructions and list each original reference separately with its front/back role or unresolved role.
3. Ask only when fit, artwork side, material claim, or another product-critical fact remains genuinely ambiguous after inspection.
4. Create `work/mockup-runs/<batch-slug>/` for state. Never place state files in the delivery folder.
5. Load `work/mockup-runs/batch-history.jsonl`. Before generation, the Visual Director must compare the proposed environment family against prior accepted batches. After each first `01.jpg` candidate is generated, compare its visible identity against prior accepted anchors before accepting it. Operations QA validates registry paths and appends only after final delivery approval.
6. If history is missing or incomplete, inventory existing delivery folders and inspect their `Men/01.jpg` and `Women/01.jpg` anchors individually, never as a collage. Record batch folder, anchor paths/checksums, identity descriptors, and environment family before approving a new identity or theme.
7. Fill the batch-lock contract before generation, including fit, artwork sides, broad model eligibility constraints, any user-required accessories, each gender's bottom-wear contrast requirement for `01.jpg`, environment family plus an explicit T-shirt/background contrast plan, output folder name, and shared-asset decisions. Leave each exact identity, hairstyle, styling, accessories, body build, and bottom-wear details pending until that gender's `01.jpg` is visually accepted.
8. Reject an environment family that violates the current cross-batch rotation rules unless the user explicitly requires that environment for the product. Do not reject a not-yet-generated identity against speculative descriptors.
9. Have the Visual Director validate the visual fields and the Operations QA validate paths/names. The Coordinator then locks the batch.

The environment is one coherent family for the batch. Before it is locked, the Visual Director must verify useful hue/luminance separation from the actual T-shirt color. Dark-on-dark/night combinations require a visibly lighter or contrasting background zone and clear garment edge lighting; blur alone is insufficient. Individual images may vary through related sub-locations, camera positions, depth, framing, action, and lighting without changing the locked theme or losing product separation.

## 2. Persistent agent setup

Spawn or reuse exactly one Coordinator, one Visual Director, and one Operations QA. Send each role the current rule path, rule hash, batch-lock path, role boundaries, and current stage. Reuse these agents through subsequent messages so accepted identity and state are not lost.

Do not run competing visual generations in parallel. Operations QA may inspect an already accepted asset while the Visual Director works on the next gated asset, provided both use the same current rule hash.

## 3. Gender generation gates

Run each gender as a gated sequence:

1. Generate `01.jpg` in the final composition ratio without an exact prelocked identity or styling description. Use recent accepted anchor descriptors only to add a concise non-reuse direction against recurring face, hair, facial-hair, and accessory combinations; this must not become a canonical identity specification before generation. Validate the result as the front, identity, styling, fit, artwork, environment, and bottom-wear anchor, including checking that its visible identity is not reused from prior batches. Before acceptance, only broad model eligibility, explicit user constraints, bottom-wear contrast, and visible cross-batch novelty apply. After acceptance, record the actual identity, hairstyle, essential styling, accessories, body build, and bottom-wear style/color/wash/silhouette as the exact continuity lock. Do not reject an otherwise suitable first `01.jpg` merely because acceptable hair, facial details, accessories, styling, or bottoms differ from a speculative preflight preference.
2. Generate one identity test from a different angle. Prefer the planned `03.jpg` when it provides a clear face and useful side perspective; otherwise use a temporary identity test outside the delivery folder.
3. Continue only after both images show the exact same person, essential styling, fit, artwork placement, and environment family.
4. Generate remaining numbered assets one at a time. Before each generation group, reread `AGENTS.md` and verify its hash. For `04.jpg`, prompt the upper frame from approximately the chin/lower lip downward and apply the artwork-first framing gate: camera-close, complete design at the largest practical scale, narrow surrounding fabric margin, and no unnecessary sleeves, body silhouette, or broad environment. The allowance for slight lower-face or nape visibility is a validation tolerance, not permission to request head-first framing. After each candidate, inspect the actual pixel dimensions before visual acceptance. If a visually acceptable candidate is a near-3:4 renderer output, perform one targeted generative exact-3:4 reframe using that candidate as the preservation reference rather than rerolling its person or content. After each candidate or recovery, run the full applicable visual checklist before accepting or saving it.
5. Record every accepted asset and rejection reason. Regenerate only the failed numbered image unless the rule file requires anchor replacement.
6. If the same critical failure repeats twice, stop and strengthen the lock or identity anchor before spending another generation.

Complete and audit one gender's gates without losing the shared batch lock, then repeat them for the other gender. Preserve each gender's exact identity, accessories, and bottom wear.

## 4. Sixth image

Reread the full rule file immediately before `06.jpg`.

- Model-worn: generate separately for each gender and validate the locked identity and visible styling.
- Model-free exception: generate and visually validate one shared source, export it once, and have Operations QA copy that exact JPEG to both gender folders. Record and compare checksums.
- Two-sided batch: set `shared_06: false` and do not use the model-free shared exception. Generate gender-specific model-worn `06` images and allocate front/back artwork coverage explicitly in the batch lock so each featured artwork remains complete and unobstructed. Do not attempt to combine both sides into one image.

The Visual Director must explicitly validate the actual plain-fabric source point, connected magnifier, truthful material wording, complete artwork, safe callout placement, and final 3:4 composition. Operations QA validates only dimensions, format, filename, and any required shared checksum.

## 5. Seventh image: reusable template

Reread `AGENTS.md` before selecting and copying the size-chart template.

1. The Coordinator resolves the locked profile (`oversized fit`, `regular fit`, or `polo fit`) and records the corresponding approved template path from `assets/size-charts/` in the batch lock.
2. The Visual Director validates the prepared final template visually: correct visible profile title, complete expected table/notes, legibility, and a coherent native 1080 x 1440 3:4 composition with no padding or letterboxing.
3. Operations QA validates the approved final source's JPEG MIME type, exact 1080 x 1440 dimensions, and SHA-256. It must reject any crop, stretch, generated/design-specific addition, logo overlay, re-encoding, or chart-content change.
4. Operations QA copies the exact approved final template unchanged to `Men/07.jpg` and `Women/07.jpg` and verifies all three files have the same SHA-256.

## 6. Export and local delivery approval

Operations QA runs `scripts/verify-delivery.sh <batch-directory>` and adds `--shared-06` when the model-free exception was selected. The script is a mechanical gate, not a visual review.

The Visual Director audits every final file individually at delivery dimensions. The Coordinator then:

1. Rereads the complete current `AGENTS.md` and rechecks its hash.
2. Confirms that the two audit reports reference that same hash and batch lock.
3. Confirms there are no unresolved rejections or skipped stage gates.
4. Confirms each accepted asset records its generated source path, source dimensions, final export method, and JPEG encoding declaration; these provenance fields support—but do not replace—visual inspection.
5. Approves local delivery or returns only the failed numbered assets to the appropriate role.

When no Drive destination is configured, Operations QA appends the immutable history entry and the batch is delivered. When Drive mirroring is configured, proceed to the publish stage below instead.

Never claim success from prompt wording alone. Acceptance requires inspecting the resulting files.

## 7. Drive mirror publish (when configured)

Read [drive-publish.md](drive-publish.md) and reread the full `AGENTS.md` before any Drive write. This is a post-local-delivery mechanics stage; it never changes the locally approved product assets.

1. Operations QA confirms the final verifier passed, all audits and the batch lock use the current rule hash, and the destination has been grounded by Drive metadata.
2. Operations QA mirrors exactly the approved local hierarchy under the configured Drive root: `<batch-folder>/Men/01.jpg` through `07.jpg`, and the same structure for `Women/`. Do not create an archive, ZIP, collage, or alternate flat upload.
3. Operations QA must stop before writing if a child batch folder with the same name already exists. Do not overwrite, duplicate, rename, move, delete, or adjust sharing. Record the conflict and ask the user for an explicit resolution.
4. After upload, Operations QA obtains Drive metadata or folder-list readback for the created batch and both gender folders, then records the observed IDs, URLs, parents, names, MIME types, and available file hash/size evidence.
5. The Coordinator approves full delivery only after the Drive audit passes. Operations QA then appends the immutable history entry containing the final identity anchors, their checksums/descriptors, environment family, and Drive publish record. Never rewrite earlier history entries to hide reuse.

If any upload fails partway, stop without automated cleanup. Record the exact successfully uploaded file IDs and the failure. Mark the publish as `partial`; the user must choose retry, manual cleanup, or a different destination.

## Rule-change recovery

If the rule hash changes at any point:

1. Freeze generation, copying, export, and delivery.
2. Read the complete updated file.
3. Record the old hash, new hash, detection stage, and affected decisions.
4. Refresh the batch lock without overwriting the user's rule file.
5. Revalidate every accepted asset potentially affected by the change.
6. Resume only after Coordinator approval.
