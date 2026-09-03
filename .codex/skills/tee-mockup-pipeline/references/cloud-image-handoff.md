# Cloud image-renderer handoff

Use this reference only for web/cloud Scheduled runs. It governs the boundary between the agent that executes the workflow and the tool that renders one image. It does not replace any product rule in `AGENTS.md`, change local/project runs, or grant new tool capabilities.

## Keep execution instructions out of the picture

The cloud agent reads the complete authoritative rules and executes the workflow itself. Do not pass the scheduled-task prompt, repository files, run summary, processing ledger, delivery manifest, or this reference wholesale to the renderer. Do not ask the renderer to execute the pipeline, read GitHub, discover Drive inputs, publish files, or illustrate completion.

The Visual Director prepares a self-contained visual brief for exactly the next authorized asset. Carry every applicable visual requirement from the current rules and accepted batch lock into that brief without weakening it. Keep operational instructions and status reporting in the agent's records, outside the rendered content.

## Before each actual image call

1. Resolve one target asset and attempt in agent state, such as `Men/01.jpg`. Select its view and applicable requirements from `AGENTS.md` and follow the existing gender gates in `workflow.md`. Do not send the whole numbered deliverable list or request a panel for each garment size.
2. Inspect the available image tool's documented input contract. Bind the individually inspected original source through its supported reference-image mechanism, not merely a filename, Drive page URL in prose, or an artwork description. Reuse the authenticated materialized source/attachment; do not substitute a thumbnail, screenshot of a report, contact sheet, or another design. Verify the reference mapping against the current group's observed Drive IDs, including when filenames are similar.
3. Label each attached image's role in the visual brief: authoritative front artwork, authoritative back artwork, or accepted same-gender identity/styling anchor. Include the references needed for the view without combining them into one image. A source mockup supplies product evidence, not a mandatory model identity; the first accepted `01` still establishes the new model under the existing rules. Later same-gender views use that accepted anchor explicitly.
4. Request one standalone product image, not a summary, dashboard, report, grid, collage, comparison sheet, or sequence of views. Describe the current view, artwork side, fit, framing/ratio, scene, material, and applicable identity constraints. Exclude operational captions, filenames, status badges, and invented completion text. This exclusion must not remove original artwork typography or the required product callouts/inset for `06`.
5. Use only supported tool parameters. Set single-image output and aspect/quality controls when exposed; otherwise express those requirements in the visual brief. Missing optional parameter names are not a capability blocker. An inability to supply the original reference through any supported mechanism is a real blocker; do not spend a text-only generation hoping to recreate it.
6. Record the exact submitted prompt, tool name, supported controls actually sent, and reference-role mapping before the call. Do not send this diagnostic record as the image prompt. The next authorized production candidate is the checkpoint: do not buy an extra capability-test image.

## Inspect, diagnose, and recover

Inspect the returned image individually and measure its actual dimensions before acceptance. A report containing drawings of T-shirts is not a product mockup and must never be split/cropped into deliverables. A depicted filename, URL, model name, or “published” status is artwork, not evidence of an external action.

If the result is the wrong artifact type, classify it as a rejected candidate, not automatic proof that the runtime cannot generate mockups. Compare the actual submitted call with the recorded target and original source: was the brief single-asset, were workflow/report instructions excluded, and were the correct reference images really supplied? Record any tool error separately from a visual failure.

Apply the existing critical-failure retry limits in `AGENTS.md` and `workflow.md`. When a correctable handoff error is established, repair that error and retry only the failed numbered asset within those limits. Reattach the original source and any valid accepted identity anchor; do not use the wrong report as a preservation reference. If the reference cannot be supplied, or the same critical failure repeats twice, stop and follow the existing recovery/terminal-marker procedure. Do not loop through equivalent prompts, lower quality, expand the batch, or claim a capability failure without evidence. Successful output still requires every normal visual and mechanical gate.

## Diagnostic evidence

Keep the exact prompt and a credential-free mapping of source Drive IDs to supplied image references in run state alongside the existing stage/rejection records. Record the target, attempt number, tool-call ID when exposed, returned artifact reference, measured dimensions, observed failure, corrective change, and next action. If an internal field is unavailable, say so; never invent it.

On a blocked run, include this renderer handoff evidence as text in the final run report (or an available downloadable text attachment), so it survives an ephemeral runtime and can be inspected by the user. Do not require a new upload capability for diagnostics, put logs in the delivery hierarchy or Drive marker folders, or write them to public GitHub. Never use image generation to create a run report. Follow `drive-intake.md` for durable status markers and `drive-publish.md` for independently verified delivery claims.
