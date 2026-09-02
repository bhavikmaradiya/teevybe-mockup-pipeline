# Google Drive cloud intake

Use this reference only when a cloud or scheduled run discovers source images from one configured Google Drive intake folder. It defines cloud input discovery and durable queue state only. It does not replace, summarize, or modify the product rules in the current workspace `AGENTS.md`, the normal runtime workflow, or Drive delivery publishing.

## Required configuration

Use this tracked configuration unless the user explicitly replaces it:

```yaml
drive_intake_folder_id: "1bOf_WaMxD9KYyzLhGQhhUgwucpZknzlz"
drive_state_folder_id: "1OS8ydBhiqa9695wYfVp1airl4rFNyL_i"
intake_timezone: "Asia/Kolkata"
intake_date: "today in intake_timezone unless the user supplies another date"
github_repository: "bhavikmaradiya/teevybe-mockup-pipeline"
github_default_branch: "main"
```

The intake folder ID authorizes read-only discovery from that folder. It does not authorize changes to the folder, its contents, or sharing. The state folder is a separate private location used only for durable processing markers; it must never be the intake folder or the delivery root.

For a web/cloud recurring Scheduled task, use the connected GitHub tool only to read the configured public repository. Do not assume a persistent checkout, local repository, shell Git access, GitHub write access, or general internet access. Before any Drive scan, use the connected GitHub tool to read the latest `github_default_branch` versions of `AGENTS.md`, `CLOUD_RUNBOOK.md`, `.codex/skills/tee-mockup-pipeline/SKILL.md`, and every reference required for the run. Confirm that the repository contents are readable. GitHub commit access is not required because queue state is stored in the separate Drive state folder.

Every scheduled run is independent. It must reread the latest repository instructions from GitHub and the current processing markers from Drive at startup; never rely on files or state retained from a prior scheduled chat.

## Flat-folder discovery for today's images

1. Resolve the target calendar date in `intake_timezone`; never use an implicit cloud-server timezone.
2. Ground `drive_intake_folder_id` through Google Drive metadata and confirm it is the intended folder.
3. List all direct children with their observed file ID, name, MIME type, parent, `createdTime`, `modifiedTime`, size, and available checksum.
4. Select direct image children whose observed `createdTime`, converted to `intake_timezone`, falls on the target date. Supported inputs are `image/jpeg`, `image/png`, and `image/webp`, plus another format only when the available image tool can inspect it safely.
5. Ignore subfolders and non-image files for generation, but record them as unexpected scan items.
6. Sort selected images deterministically by `createdTime`, then file ID. Inspect every selected image individually at original quality; never create a collage, contact sheet, or minimap.

The intake folder remains flat. Do not require the user to create date folders, design subfolders, or adopt a new filename convention. Do not move older files into today's selection by using `modifiedTime` as a substitute for `createdTime`.

## Grouping one or two images into a design

Each design group must contain one source image or a verified front/back pair. Existing filenames may be arbitrary and inconsistent, so filenames and upload order are grouping hints rather than authoritative product evidence.

For every selected image, the Visual Director must:

1. Inspect the image independently and record the visible garment side, artwork, T-shirt color, fit evidence, model/reference context, and any visible product identifiers.
2. Compare normalized filename stems, including obvious trailing sequence or side markers, only as candidate hints. Do not impose a required naming pattern.
3. Consider close upload-time adjacency only as a secondary hint. Never group files solely because they were uploaded consecutively.
4. Pair two images only when individual visual inspection establishes that they are complementary front/back references for the same T-shirt design. The garment color, product context, and artwork relationship must be coherent, and the two visible sides must not conflict.
5. Leave an image as a one-image design when no verified mate exists.

Never group more than two images into one design. Never infer a pair from a shared generic name such as `Photo 1`/`Photo 2`, a common model, or a common T-shirt color without confirming the actual product relationship visually. Never treat the trailing `1` in a legitimate design name as automatically being a sequence marker.

If two or more plausible groupings remain after individual inspection, or the side/product relationship is uncertain, record those source fingerprints as blocked with `ambiguous-grouping` in the Drive state folder and stop them before generation. Continue to another clearly resolved design only after the blocked marker is confirmed by Drive readback.

## Drive processing ledger

Use the configured separate `drive_state_folder_id` as the cross-run source of truth for whether an intake group has been processed. Use Drive folders as zero-byte durable markers so queue state does not depend on GitHub write access or consume file-storage quota. Do not use an ephemeral checkout, local-only `work/` state, source-file moves, filename changes, or output-folder guesses as the processing record.

The state hierarchy is:

```text
<state-root>/
  ledger-initialized--v1/
  group--<design_group_id>/
    source--front--<Drive-file-id>--<source-fingerprint>/
    source--back--<Drive-file-id>--<source-fingerprint>/   # only for a verified pair
    event--<UTC-basic-timestamp>--claimed--<batch-id>/
    event--<UTC-basic-timestamp>--delivered--<batch-id>/
    event--<UTC-basic-timestamp>--blocked--<reason-token>/
  blocked-source--<Drive-file-id>--<source-fingerprint>--ambiguous-grouping/
```

The single initialization marker identifies the schema version and is not a processed design. Use filesystem-safe lowercase tokens in marker names. Build each source fingerprint from the observed Drive file ID, created time, modified time, size, and available checksum. Build `design_group_id` from the sorted source fingerprints. Never use filenames alone as identity. The observed source filename and metadata remain in the run scan report; the durable markers intentionally store only stable IDs, fingerprints, side, status, timestamp, batch ID, and a concise reason token.

For each resolved group:

- No matching group marker: `unprocessed`.
- A `delivered` event exists: skip permanently.
- The latest event is `blocked`: skip until the user explicitly resolves or resubmits it.
- A `claimed` event exists without a later terminal event: treat it as an interrupted run; do not automatically regenerate it.

If a source file ID already appears in a delivered group's source marker but its fingerprint has changed, treat it as a revised prior input and create a blocked-source marker for explicit user confirmation instead of silently creating a second batch.

## Connector-based claim and terminal markers

Process only one design group at a time and use only one scheduled worker for the intake folder.

Before the first generation call for a group:

1. List the state root immediately before claiming and confirm that no `group--<design_group_id>` marker exists.
2. Create `group--<design_group_id>` directly under the state root.
3. Create its one or two exact source-marker child folders, then its `claimed` event child folder.
4. List the state root again and require exactly one matching group marker. List that group and confirm every expected source marker plus the claimed event before generation.

If any create or readback fails, if a duplicate matching group folder is observed, or if the connector cannot create Drive folders, do not generate. Reread the state root; if another run claimed the group, skip it. Never use GitHub commits, shell Git, source-folder markers, output-folder guesses, or an ephemeral local ledger as a workaround. The single-worker requirement is mandatory because Google Drive folder names are not an atomic uniqueness constraint.

After complete pipeline approval and verified Drive output persistence, create the `delivered` event child and confirm it by group-folder readback. If ambiguity, repeated critical failure, or another terminal blocker stops a claimed design, create a `blocked` event child with the exact concise reason token and confirm it before selecting another design.

A scheduled run must not finish successfully while a group it claimed lacks a terminal marker in Drive. An interrupted claimed group requires manual recovery or explicit user authorization to resume.

The state root stores processing markers only. Do not upload source images, generated candidates, delivery JPEGs, credentials, or `work/` state there. Approved final JPEGs belong only under the separate destination governed by `drive-publish.md`.

## Per-design handoff

For an unprocessed resolved group, download or materialize its source files one at a time through authenticated Google Drive access. Preserve their original bytes, names, and observed metadata in run state. Pass the individually inspected files and resolved front/back roles into the normal TeeVybe batch preflight.

The Visual Director's resolved side labels become the intake handoff, but all normal artwork-side and reference validations still apply. If later inspection reveals that the grouping or side decision was wrong, block the group rather than guessing, swapping, merging, or generating.

After handoff, follow the complete current `AGENTS.md`, `SKILL.md`, `workflow.md`, `agent-contracts.md`, and `model-routing.md` without alteration. Intake discovery does not relax any batch gate.

## Source safety

- Keep the Drive intake folder and every source file read-only.
- Do not rename, move, delete, overwrite, share, reorganize, or mark source files in Drive.
- Do not create completion markers inside Drive.
- Drive output publishing is a separate post-approval stage governed only by `drive-publish.md`.

## Scan record

Store a scan report in run state containing the observed folder metadata, target date/timezone, every direct child considered, individual inspection notes, proposed and accepted groupings, unexpected items, source fingerprints, design-group IDs, ledger decisions, and the next eligible group. The scan report is discovery evidence only; it is not visual acceptance or batch approval.
