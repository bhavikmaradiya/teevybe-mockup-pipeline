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

- a writable checkout of this complete repository;
- access to every supplied reference through a durable cloud attachment or storage path;
- a configured flat Google Drive intake folder, private-GitHub read/write access, and the tracked `cloud-state/drive-intake-history.jsonl` ledger when Drive discovery is enabled;
- the image-generation and generative-editing capabilities required by the skill;
- support for the models and persistent role agents required by `model-routing.md`, or an explicitly disclosed runtime fallback that preserves all role boundaries;
- persistent storage for delivery files and required run state when the checkout is temporary; and
- separately configured credentials and permissions for any optional external publishing destination.

Repository contents do not grant tool access, account access, credentials, or persistent storage. A local `/tmp` or Downloads path from another device is not a cloud-accessible reference. If a required capability, input, or permission is missing, stop before generation and report the blocker.

## Cloud input handoff

Supply the task with the user's request exactly as given, including:

- the requested fit, when provided;
- each original reference as an individual durable attachment or cloud path;
- any explicit front/back role or artwork-side instruction;
- any explicit environment, styling, accessory, material, delivery, or publishing instruction; and
- a durable destination for approved outputs when the runner is ephemeral.

Do not rewrite the user's request into inferred product rules. The complete repository instructions determine how the inputs are analyzed and executed.

## Ready-to-use cloud or scheduled task prompt

```text
Run the TeeVybe mockup request supplied with this task from the checked-out repository.

Before taking any batch action, open and read the complete repository-root AGENTS.md and the complete .codex/skills/tee-mockup-pipeline/SKILL.md. Then read every file that the skill requires for the current run, including its workflow, agent-contract, and model-routing references, plus drive-intake.md when source artwork is discovered from Google Drive and drive-publish.md only if Drive publishing is requested. Treat AGENTS.md as the live and sole source of product rules. Do not replace it with this prompt, a summary, remembered instructions, or inferred rules.

Verify the cloud capability gate in CLOUD_RUNBOOK.md before spending image-generation credits. Preserve the supplied user request and inspect every supplied reference individually at original quality. Use the pipeline skill's required persistent roles, records, stage gates, validation, retry control, export process, and final audits exactly as written in the tracked files. Reread AGENTS.md wherever those files require it and detect changes using the required hash workflow.

If a required repository file, input, model or role capability, image tool, credential, permission, or persistent output location is unavailable, stop and report the exact blocker. Do not improvise a reduced workflow. Do not claim delivery until every approval and verification required by the current repository files has passed.
```

Attach the actual user request and durable reference files to that prompt. Do not paste shortened copies of the repository rules into the scheduled task.

## Local-safety boundary

Using or updating this cloud bootstrap does not alter the local generation workflow. Local runs continue to use the same root `AGENTS.md`, project-local pipeline skill, reference files, approved assets, and verifier. Generated deliveries, `work/` state, credentials, and machine-specific Codex configuration remain excluded from Git by `.gitignore`.

## Maintenance

- Change product rules only in `AGENTS.md`.
- Change pipeline behavior only in `.codex/skills/tee-mockup-pipeline/` and its referenced files.
- Change this file only when cloud bootstrapping, capability checks, input accessibility, or persistence guidance changes.
- Never add a shortened copy of product or pipeline rules here.
