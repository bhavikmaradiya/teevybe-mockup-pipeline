# TeeVybe Cloud Bootstrap

This file only connects a cloud or scheduled Codex task to the complete pipeline contained in this repository. It does not restate, summarize, interpret, or replace any product or workflow rule.

## Authoritative files

The cloud task must read and follow these tracked files directly:

1. `AGENTS.md`
   - The live and sole source of TeeVybe product and mockup rules.
   - Read it completely at startup and again at every stage gate it specifies.
2. `.codex/skills/tee-mockup-pipeline/SKILL.md`
   - The pipeline entry point and role boundaries.
3. `.codex/skills/tee-mockup-pipeline/references/workflow.md`
   - The complete runtime sequence and stage gates.
4. `.codex/skills/tee-mockup-pipeline/references/agent-contracts.md`
   - The required batch lock, stage, asset, rejection, audit, Drive, and history records.
5. `.codex/skills/tee-mockup-pipeline/references/model-routing.md`
   - The required persistent roles, models, responsibilities, and escalation boundaries.
6. `.codex/skills/tee-mockup-pipeline/references/drive-publish.md`
   - Read only when Drive publishing is requested.
7. `.codex/skills/tee-mockup-pipeline/references/drive-intake.md`
   - Read only when a cloud or scheduled run discovers source artwork from Google Drive.
8. `scripts/verify-delivery.sh`
   - The final mechanical delivery verifier invoked according to the workflow.
9. `assets/size-charts/`
   - The approved reusable chart sources selected according to `AGENTS.md`.

If any instruction conflicts, is unclear, or appears incomplete, reread the full current `AGENTS.md` and pipeline skill. Do not use this bootstrap file to resolve product-rule questions, and do not rely on remembered or shortened versions of repository instructions.

## Cloud capability gate

Before beginning a run, verify that the cloud environment has:

- GitHub read access to the public repository `bhavikmaradiya/teevybe-mockup-pipeline` and its `main` branch;
- connected-GitHub file-write/commit capability for `cloud-state/drive-intake-history.jsonl` when Drive discovery is enabled;
- either the `$tee-mockup-pipeline` skill available to the scheduled chat or connected-GitHub read access to its complete tracked `SKILL.md` and required references; when the skill is exposed by name, invoke it, but always ground the run in the latest repository copies;
- access to every supplied reference through a durable cloud attachment or storage path;
- a configured flat Google Drive intake folder and the tracked GitHub ledger when Drive discovery is enabled;
- the image-generation and generative-editing capabilities required by the skill;
- either the normal persistent role-agent topology or a Sol session capable of using the explicit cloud-only fallback in `model-routing.md`;
- persistent storage for delivery files and required run state when the checkout is temporary; and
- separately configured credentials and permissions for any optional external publishing destination.

Repository contents do not grant tool access, account access, credentials, installed-skill availability, or persistent storage. A web/cloud recurring Scheduled task must not assume it retains a checkout or filesystem state from an earlier run. A local `/tmp` or Downloads path from another device is not a cloud-accessible reference. If a required capability, input, or permission is missing, stop before generation and report the blocker.

## Cloud input handoff

Supply the task with the user's request exactly as given, including:

- the requested fit, when provided;
- each original reference as an individual durable attachment or cloud path;
- any explicit front/back role or artwork-side instruction;
- any explicit environment, styling, accessory, material, delivery, or publishing instruction; and
- a durable destination for approved outputs when the runner is ephemeral.

Do not rewrite the user's request into inferred product rules. The complete repository instructions determine how the inputs are analyzed and executed.

## Ready-to-use cloud or scheduled task prompt

Replace only `<DRIVE_INTAKE_FOLDER_ID>` and `<CONFIRMED_MATERIAL>` before saving the task. The default fit below is oversized; change that single value only when the scheduled intake is for another fit.

```text
Use the connected GitHub tool to open the public repository bhavikmaradiya/teevybe-mockup-pipeline at its main branch, then run the TeeVybe cloud mockup intake. If $tee-mockup-pipeline is exposed as an available skill in this scheduled chat, invoke it. In every case, read and follow its latest tracked SKILL.md and required references from that repository. Do not assume a persistent checkout or use shell Git.

Runtime configuration:
- Google Drive intake folder ID: <DRIVE_INTAKE_FOLDER_ID>
- The intake folder is flat; source filenames must remain unchanged.
- Intake date: today in Asia/Kolkata.
- Default user-requested fit for every discovered design: oversized fit.
- Confirmed truthful material callout: <CONFIRMED_MATERIAL>.
- GitHub repository: bhavikmaradiya/teevybe-mockup-pipeline.
- GitHub branch: main.
- GitHub processing ledger: cloud-state/drive-intake-history.jsonl in that repository.
- After a batch passes every required approval and audit, publish it to the configured destination governed by drive-publish.md.

Before taking any Drive, GitHub-ledger, or batch action, use the connected GitHub tool to read the complete latest main-branch contents of repository-root AGENTS.md, CLOUD_RUNBOOK.md, and .codex/skills/tee-mockup-pipeline/SKILL.md. Read every repository reference required by the skill for this run, including workflow.md, agent-contracts.md, model-routing.md, drive-intake.md, and drive-publish.md. Treat AGENTS.md as the live and sole source of product rules. Do not replace any tracked instruction with this prompt, a summary, remembered instructions, or inferred rules. Repeat this repository read on every scheduled run because scheduled chats do not share a persistent working copy.

Verify the cloud capability gate before spending image-generation credits. Follow drive-intake.md exactly to scan today's direct image files in the configured flat Drive folder, inspect them individually, resolve one-image designs or verified two-image design groups, and consult the GitHub ledger. Use only the connected GitHub tool to reread and commit the required claimed and terminal ledger events; require commit confirmation and readback before proceeding. Never process a group whose latest ledger state prevents automatic processing.

If persistent Terra/Luna agent spawning is unavailable but Sol and the remaining required tools are available, disclose and use the cloud-only Sol fallback in model-routing.md. Execute Coordinator, Visual Director, and Operations QA as sequential logical phases with separate records and deterministic mechanical checks. Do not stop solely because Terra/Luna spawning is unavailable, and do not apply this fallback to any other missing capability.

Process only one resolved design group at a time. Pass its original Drive sources and the runtime configuration above into the complete tee-mockup-pipeline workflow. Follow the tracked files directly for all roles, records, stage gates, generation, validation, retry control, export, delivery, publishing, and terminal-ledger behavior. Reread AGENTS.md wherever required and use its current recorded hash throughout the run.

If there are no eligible unprocessed images today, finish with a no-input report and make no generation calls. If a required repository instruction, input, grouping decision, model or role capability, image tool, connected-GitHub read/commit operation, Drive operation, credential, permission, or durable output location is unavailable, follow the applicable tracked blocker procedure. Do not improvise a reduced workflow, modify Drive source files, use shell Git or force-push Git history, or claim delivery before all required approvals and verification pass.
```

Do not attach duplicate source images to this scheduled prompt; the configured Drive folder is the intake. Do not paste shortened copies of repository rules into the task.

## Local-safety boundary

Using or updating this cloud bootstrap does not alter the local generation workflow. Local runs continue to use the same root `AGENTS.md`, project-local pipeline skill, reference files, approved assets, and verifier. Generated deliveries, `work/` state, credentials, and machine-specific Codex configuration remain excluded from Git by `.gitignore`.

## Maintenance

- Change product rules only in `AGENTS.md`.
- Change pipeline behavior only in `.codex/skills/tee-mockup-pipeline/` and its referenced files.
- Change this file only when cloud bootstrapping, capability checks, input accessibility, or persistence guidance changes.
- Never add a shortened copy of product or pipeline rules here.
