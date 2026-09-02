# Google Drive cloud intake

Use this reference only when a cloud or scheduled run is configured to discover source artwork from a Google Drive intake folder. It defines input discovery and queue state only. It does not replace, summarize, or modify the product rules in the current workspace `AGENTS.md`, the runtime workflow, or the Drive delivery-publish procedure.

## Required configuration

The scheduled task must receive these configured values; never guess them:

```yaml
drive_intake_root_id: "user-approved Google Drive folder ID"
intake_timezone: "Asia/Kolkata"
intake_date: "today in intake_timezone unless the user supplies a date"
intake_ledger_path: "durable path to work/mockup-runs/drive-intake-history.jsonl"
```

The Drive folder ID is configuration, not blanket permission to change its contents or sharing. Ground the folder by Drive metadata before every scan and preserve all source files and folders unchanged.

The intake ledger must survive scheduled runs. If the checkout is ephemeral and the configured ledger cannot be restored from persistent storage, stop before generation; do not rescan as if every file were new.

## Drive layout and naming contract

Use one date folder directly below the configured intake root:

```text
<intake root>/
  YYYY-MM-DD/
    <design-key>__front.<ext>
    <design-key>__back.<ext>      # optional
    <another-design>__front.<ext>
```

- The date folder name is the calendar date in `intake_timezone`.
- A design group contains exactly one or two image files.
- Every filename must use the exact form `<design-key>__front.<ext>` or `<design-key>__back.<ext>`.
- `<design-key>` must be identical for the two files belonging to one design and must not contain `__front` or `__back` elsewhere.
- Supported source MIME types are `image/jpeg`, `image/png`, and `image/webp` unless the current image tool supports another user-supplied format.
- A one-image design must still include its correct `__front` or `__back` suffix.
- A two-image design must contain one `__front` and one `__back`. Duplicate sides, an unlabeled image, more than two files for one key, or conflicting design keys are intake failures and must not reach generation.

Do not infer grouping from visual similarity, upload order, consecutive Drive results, generic names such as `Photo 1`, or timestamps. If existing files do not follow the naming contract, stop those files as `needs-input-fix` and report the exact rename or regrouping needed.

## Today's discovery

1. Resolve today's date in `intake_timezone`; never use an implicit server timezone.
2. Ground the configured intake root by Drive metadata and confirm it is a folder.
3. List its direct children and select the single direct child whose name exactly equals today's `YYYY-MM-DD` value.
4. If today's folder does not exist, finish the scan successfully with `no-input`; do not create it unless the user explicitly requested folder creation.
5. Ground today's folder and list all of its direct children with file ID, name, MIME type, parent, created time, modified time, size, and available checksum.
6. Ignore subfolders and non-image files for generation, but report unexpected items in the scan record.
7. Parse and group valid image names by exact `<design-key>`.
8. Sort groups deterministically by design key. Process one complete group at a time; do not run different designs in parallel.

The dated folder determines the requested day. Do not additionally reject a correctly placed file merely because Drive's original `createdTime` is older—for example, when an older file was copied or moved into today's intake folder.

## Durable unprocessed-state ledger

Use append-only JSON Lines at the configured durable `intake_ledger_path`. Never rewrite earlier events. Each event must contain:

```json
{
  "event": "claimed|delivered|blocked",
  "recorded_at": "ISO-8601 timestamp",
  "intake_date": "YYYY-MM-DD",
  "intake_folder_id": "observed Drive folder ID",
  "design_key": "exact parsed design key",
  "source_files": [
    {
      "side": "front|back",
      "drive_file_id": "observed ID",
      "name": "observed filename",
      "mime_type": "observed MIME type",
      "modified_time": "observed Drive value",
      "size_bytes": null,
      "checksum": "observed checksum when available"
    }
  ],
  "source_fingerprint": "SHA-256 of the canonical sorted source-file identity record",
  "batch_id": "",
  "delivery_folder": "",
  "reason": ""
}
```

Build the fingerprint from the sorted source records using their observed Drive file IDs, side labels, modified times, sizes, and available checksums. Do not use filenames alone.

For each discovered group:

- No prior event for its fingerprint: it is `unprocessed`.
- Latest event is `delivered`: skip it permanently.
- Latest event is `blocked`: skip it until the user explicitly resolves or resubmits it.
- Latest event is `claimed` without a later terminal event: treat it as an interrupted run and stop it for manual recovery; never automatically regenerate it.

Before the first image-generation call for a group, append and durably persist its `claimed` event. If that write cannot be confirmed, do not generate.

After final delivery approval and required output persistence, append `delivered`. If the batch is stopped by ambiguity, missing capability, repeated critical failure, or unrecoverable validation failure, append `blocked` with the exact reason before moving to another design. A blocked group must not be automatically retried by the next scheduled run.

When a source file is intentionally revised, use a new design key such as `<design-key>-v2` or obtain explicit user approval to process its new fingerprint. A changed fingerprint alone must not silently create a second batch from the same design key.

## Per-design handoff

For each unprocessed group, download or materialize its files one at a time using observed Drive metadata and authenticated Drive file access. Preserve original bytes and names in run state. Inspect each image independently at original quality.

Pass the exact observed front/back paths and the user's scheduled-task defaults into the normal preflight. Filename side labels establish the submitted role, but the Visual Director must still verify that each image visibly represents the named garment side. If a label conflicts with visible orientation or two files appear not to belong to the same design, append `blocked` and do not guess, swap, merge, or generate.

After this handoff, follow `AGENTS.md`, `SKILL.md`, `workflow.md`, `agent-contracts.md`, and `model-routing.md` without alteration. Intake discovery does not relax any batch gate.

## Source safety and concurrency

- Intake is read-only. Do not rename, move, delete, overwrite, share, or reorganize source files or folders.
- Do not place completion markers inside the user's Drive intake tree.
- Use a single scheduled worker for one intake root. If multiple workers are possible, the ledger store must provide an atomic claim; otherwise stop rather than risk duplicate generations.
- Do not begin a second design until the current design has a durably recorded `delivered` or `blocked` terminal event.
- Drive output publishing, when configured, remains a separate post-approval stage governed only by `drive-publish.md`.

## Scan result

Record a compact scan report in run state containing the observed root and date-folder IDs, intake date/timezone, all direct child metadata, parsed groups, unexpected items, source fingerprints, ledger decisions, and the next eligible design key. A scan report is evidence of discovery only; it is not visual acceptance or batch approval.
