# Google Drive mirror publish

Use this reference only when the user has explicitly supplied or approved a Drive destination for the batch. It extends delivery mechanics and never changes the current workspace `AGENTS.md` or the locally approved assets.

## Configured destination

The current approved TeeVybe Drive root is:

- Folder ID: `1w9Y6QWb_Rmdzob7J6VoBdLQdryqkoewv`
- URL: `https://drive.google.com/drive/folders/1w9Y6QWb_Rmdzob7J6VoBdLQdryqkoewv`

Treat this tracked value as configuration, not permission to alter the root. Before every publish, read Drive metadata and verify it remains a folder. Preserve its existing contents, hierarchy, and sharing state.

The intake folder's read-only rule does not make the entire Google Drive connector read-only. Publishing uses separate write authorization against this destination. Before spending generation credits in an ephemeral cloud run, verify that folder creation, JPEG upload, and readback are available and that the connected Drive account has sufficient storage quota. A quota failure is a publish-capability failure; do not generate a batch that cannot be durably stored.

## Required outcome

Mirror the exact local delivery hierarchy beneath the configured root without creating a ZIP:

```text
<Drive root>/
  <approved batch folder>/
    Men/
      01.jpg ... 07.jpg
    Women/
      01.jpg ... 07.jpg
```

Upload only the locally approved final JPEGs, `01.jpg` through `07.jpg`. Do not upload template sources, prompts, manifests, generated candidates, state files, a second chart format, or a separate logo asset.

## Publish gate

1. Reread the full workspace `AGENTS.md`; compare its SHA-256 with the current batch lock and both final audit reports.
2. Run the local delivery verifier and require success. Confirm the required shared checksums before any Drive mutation.
3. Read metadata for the Drive root. Then list its direct children and check for a child whose name exactly equals the approved batch folder.
4. If that name already exists, stop and record `drive_publish_status: blocked`. Do not overwrite it, create a duplicate with a suffix, upload inside it, or change its sharing. Ask the user for a replacement, versioning, or cleanup decision.
5. Create the new batch folder, then `Men` and `Women` directly under it. Do not create any other folders.
6. Upload the fourteen approved JPEGs using their exact numeric names and the correct gender-folder parent. Preserve `image/jpeg` MIME type.
7. List/read back the new batch folder and both gender folders. Confirm two direct children named exactly `Men` and `Women`, seven direct JPEGs in each folder named `01.jpg` through `07.jpg`, and no unexpected published items.
8. Record only observed Drive IDs/URLs and metadata. Where the connector exposes file size or checksum, compare it against the local audit and record the result. Verify the two uploaded `07.jpg` files match the approved shared local checksum and are the two separately uploaded copies of the exact same local source.
9. Mark the stage `pass` only after this readback. The Coordinator can then mark the batch fully delivered.

## Failure and recovery

If a create or upload operation fails, stop immediately. Never delete, replace, or retry automatically. Preserve the partial hierarchy and record created folder IDs and every successful upload in the stage result so the user can choose recovery. Do not change sharing permissions at any point.

Use the Google Drive connector for Drive lifecycle operations. Before every Drive write, reuse the verified destination metadata and after every write, obtain connector readback; never synthesize a Drive URL or file ID.
