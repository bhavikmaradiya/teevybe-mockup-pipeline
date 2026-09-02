# Agent Handoff Contracts

Use YAML or JSON with these fields. Store contracts under `work/mockup-runs/<batch-slug>/`, never in the delivery folder. Every report must include the current `agents_sha256`; reports with a stale hash are invalid.

## Batch lock

```yaml
batch_id: ""
batch_slug: ""
status: "draft|locked|paused|local-delivery-approved|drive-publish-partial|delivered"
agents_path: ""
agents_sha256: ""
input_mode: "one-sided|two-sided"
front_reference: "absolute path or blank"
back_reference: "absolute path or blank"
fit: "regular fit|oversized fit|polo fit"
tshirt_color: ""
male_identity_anchor: "pending until accepted Men/01; then exact visible identity and styling description"
female_identity_anchor: "pending until accepted Women/01; then exact visible identity and styling description"
male_bottom_wear_constraint: "pre-01 contrast requirement and any user constraint"
female_bottom_wear_constraint: "pre-01 contrast requirement and any user constraint"
male_bottom_wear: "pending until accepted Men/01; then exact style, color, wash, and silhouette"
female_bottom_wear: "pending until accepted Women/01; then exact style, color, wash, and silhouette"
user_required_accessories:
  men: []
  women: []
essential_accessories:
  men: "pending until accepted Men/01; then lock visible essentials"
  women: "pending until accepted Women/01; then lock visible essentials"
environment_family: ""
environment_variation_limits: ""
environment_contrast_plan: "specific hue/luminance/background-zone separation from the T-shirt color"
prior_batches_compared: []
identity_uniqueness_verified: false
environment_rotation_verified: false
material_callout: ""
shared_06: false
men_06_artwork_side: "front|back"
women_06_artwork_side: "front|back"
shared_07: true
size_chart_template_path: "absolute approved source path"
size_chart_template_sha256: ""
delivery_folder: "absolute path"
drive_publish_required: false
drive_root_folder_id: ""
drive_root_url: ""
drive_publish_status: "not-configured|pending|pass|partial|blocked|fail"
approved_by_visual: false
approved_by_operations: false
approved_by_coordinator: false
```

Do not approve the pre-generation lock until references, fit, sides, broad model eligibility, any user-required accessories, bottom-wear contrast constraints, environment family/contrast plan, and output folder are resolved. Exact identity, hairstyle, body build, essential styling, accessories, and bottom-wear fields must remain pending until each gender's accepted `01.jpg`; the Coordinator then updates the same lock before authorizing that gender's next asset.

## Stage result

```yaml
batch_id: ""
stage: "preflight|men-anchor|men-generation|women-anchor|women-generation|fabric|size-chart|logo|export|local-delivery|drive-publish|delivery"
agents_sha256: ""
status: "pass|fail|paused"
inputs: []
outputs: []
checks_performed: []
failed_checks: []
rejection_reason: ""
attempt_number: 1
next_action: ""
reviewer_role: "coordinator|visual-director|operations-qa"
```

A visual stage cannot pass without a Visual Director report. A mechanical stage cannot pass without an Operations QA report. Coordinator approval cannot replace either specialist report.

## Accepted asset record

```yaml
batch_id: ""
gender: "Men|Women|Shared"
number: "01|02|03|04|05|06|07"
path: "absolute path"
sha256: ""
agents_sha256: ""
identity_anchor_sha256: ""
generated_source_path: ""
generated_source_width: 0
generated_source_height: 0
final_export_method: ""
jpeg_encoding_passes_declared: 1
visual_status: "pass|fail|not-applicable"
mechanical_status: "pass|fail|pending"
accepted_attempt: 1
accepted_by_visual: "agent id"
notes: ""
```

For a shared asset, record the validated source plus both copied destinations and prove checksum identity.

## Rejection record

```yaml
batch_id: ""
gender: "Men|Women|Shared"
number: ""
attempt: 1
agents_sha256: ""
category: "identity|artwork|side|fit|framing|environment|fabric|text|logo|dimensions|format|structure|other"
evidence: "specific visible or mechanical failure"
corrective_constraint: "single targeted correction for the next attempt"
```

After the second rejection for the same critical category, mark the stage paused and strengthen the relevant lock or identity anchor.

## Final audit

```yaml
batch_id: ""
agents_sha256: ""
batch_lock_sha256: ""
visual_audit: "pass|fail"
mechanical_audit: "pass|fail"
unresolved_assets: []
men_07_sha256: ""
women_07_sha256: ""
size_chart_template_sha256: ""
shared_07_identical: false
men_06_sha256: ""
women_06_sha256: ""
shared_06_required: false
shared_06_identical: "true|false|not-applicable"
source_provenance_complete: false
history_entry_appended: false
coordinator_decision: "deliver|return-for-correction"
drive_publish_status: "not-configured|pending|pass|partial|blocked|fail"
drive_root_folder_id: ""
drive_root_url: ""
drive_batch_folder_id: ""
drive_batch_folder_url: ""
drive_men_folder_id: ""
drive_women_folder_id: ""
drive_file_records: []
```

## Drive file record

Use one record for every uploaded JPEG after Drive metadata/list readback:

```yaml
local_path: "absolute path"
local_sha256: ""
drive_file_id: ""
drive_url: ""
drive_parent_id: ""
drive_name: "01.jpg"
drive_mime_type: "image/jpeg"
drive_size_bytes: null
drive_checksum: ""
verified: false
```

The Drive record is valid only after an observed connector result or metadata/list readback. Never predict IDs or URLs.

## Cross-batch history entry

Append one JSON object per delivered batch to `work/mockup-runs/batch-history.jsonl`:

```json
{
  "batch_id": "",
  "delivered_at": "ISO-8601 timestamp",
  "agents_sha256": "",
  "delivery_folder": "absolute path",
  "male_anchor_path": "absolute path to Men/01.jpg",
  "male_anchor_sha256": "",
  "male_identity_descriptor": "",
  "female_anchor_path": "absolute path to Women/01.jpg",
  "female_anchor_sha256": "",
  "female_identity_descriptor": "",
  "environment_family": ""
  ,"drive_publish_status": "not-configured|pass"
  ,"drive_batch_folder_url": ""
}
```

Use the registry as an index to individually inspect prior anchors; a checksum alone cannot prove that two generated people are visually different.
