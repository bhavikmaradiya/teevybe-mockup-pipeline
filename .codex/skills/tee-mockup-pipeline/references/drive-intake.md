# Google Drive cloud intake

Use this reference only when a cloud or scheduled run discovers source images from one configured Google Drive intake folder. It defines cloud input discovery and durable queue state only. It does not replace, summarize, or modify the product rules in the current workspace `AGENTS.md`, the normal runtime workflow, or Drive delivery publishing.

## Required configuration

The scheduled task must receive these values; never guess them:

```yaml
drive_intake_folder_id: "user-approved Google Drive folder ID"
intake_timezone: "Asia/Kolkata"
intake_date: "today in intake_timezone unless the user supplies another date"
github_ledger_path: "cloud-state/drive-intake-history.jsonl"
```

The Drive folder ID authorizes read-only discovery from that folder. It does not authorize changes to the folder, its contents, or sharing.

The cloud checkout must have permission to fetch the repository and push ledger commits to its private GitHub remote. Before generation, confirm that the current branch is synchronized and that `github_ledger_path` exists. If GitHub state cannot be read or a ledger commit cannot be pushed, stop before spending generation credits.

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

If two or more plausible groupings remain after individual inspection, or the side/product relationship is uncertain, record those files as `blocked` with `ambiguous-grouping` and stop them before generation. Continue to another clearly resolved design only after the blocked ledger event is durably pushed.

## GitHub processing ledger

Use the tracked append-only JSON Lines file at `cloud-state/drive-intake-history.jsonl`. This file is the cross-run source of truth for whether a Drive input group has been processed. Do not use an ephemeral checkout, local-only `work/` state, Drive moves, filename changes, or output-folder guesses as the processing record.

Every event after the initialization record must contain:

```json
{
  "event": "claimed|delivered|blocked",
  "recorded_at": "ISO-8601 timestamp",
  "intake_date": "YYYY-MM-DD",
  "intake_timezone": "Asia/Kolkata",
  "drive_intake_folder_id": "observed folder ID",
  "design_group_id": "stable SHA-256 of the sorted source fingerprints",
  "source_files": [
    {
      "drive_file_id": "observed ID",
      "name": "observed filename",
      "side": "front|back",
      "mime_type": "observed MIME type",
      "created_time": "observed Drive value",
      "modified_time": "observed Drive value",
      "size_bytes": null,
      "checksum": "observed checksum when available",
      "source_fingerprint": "SHA-256 of the canonical observed source identity"
    }
  ],
  "batch_id": "",
  "delivery_folder": "",
  "reason": ""
}
```

Build each source fingerprint from the observed Drive file ID, created time, modified time, size, and available checksum. Build `design_group_id` from the sorted source fingerprints. Never use filenames alone as identity.

For each resolved group:

- No ledger event for its `design_group_id`: `unprocessed`.
- Latest event is `delivered`: skip permanently.
- Latest event is `blocked`: skip until the user explicitly resolves or resubmits it.
- Latest event is `claimed` without a later terminal event: treat it as an interrupted run; do not automatically regenerate it.

If a source file ID already belongs to a delivered group but its fingerprint has changed, treat it as a revised prior input and block it for explicit user confirmation instead of silently creating a second batch.

## Atomic claim and terminal commits

Process only one design group at a time and use only one scheduled worker for the intake folder.

Before the first generation call for a group:

1. Fetch the latest GitHub branch state without discarding local/user changes.
2. Reread the ledger and confirm the group is still unprocessed.
3. Append its `claimed` event.
4. Commit only the ledger change with a message containing the design-group ID.
5. Push the commit and confirm the remote accepted it.

If synchronization, commit, or push fails, do not generate. After a non-fast-forward rejection, fetch and reread the remote ledger; if another run claimed the group, skip it. Do not force-push, overwrite history, or resolve a concurrent claim by generating anyway.

After complete pipeline approval and durable output persistence, append `delivered`, commit, push, and confirm the remote state. If ambiguity, missing capability, repeated critical failure, or another terminal blocker stops the design, append `blocked` with the exact reason, commit, and push before selecting another design.

A scheduled run must not finish successfully while a group it claimed lacks a durably pushed terminal event. An interrupted `claimed` group requires manual recovery or explicit user authorization to resume.

The GitHub ledger stores metadata and status only. Do not commit source images, generated candidates, delivery JPEGs, credentials, or `work/` state unless the user separately changes the repository policy.

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
