---
name: skill-creator
description: Create or update Codex skills under `~/.codex/skills` (SKILL.md + optional `references/`, `scripts/`, `assets/`). Use when the user asks to make a new skill or improve an existing skill, including defining triggers (description), writing concise instructions, and adding reusable resources.
---

# Skill Creator

## Goal
Create skills that are:
- easy to trigger (clear `description`)
- cheap to read (lean SKILL.md body; move detail to `references/`)
- reliable (use `scripts/` for deterministic or repeated code)

## How skills work (mental model)
- Only `name` + `description` are "always visible" and used for triggering.
- SKILL.md body is not injected into context; open/read it only when needed.
- Other files are loaded only when needed (or scripts can be executed without reading).

## Core rules
1) **Frontmatter is YAML + body.**
   - Required (sanitized to one line, non-empty):
     - `name` (<= 100 chars)
     - `description` (<= 500 chars)
   - Extra YAML keys are ignored (prefer omitting unless you truly need them).
2) Prefer checklists + templates over long prose.
3) Don't add extra docs (no README/CHANGELOG/etc.). Keep only files that help the agent do the job.
4) If SKILL.md mentions a file, create it (no dead links).

## Workflow (repeatable)
### 1) Understand the skill with concrete examples
Ask for 2-5 examples of how the user expects to invoke the skill.

Minimum questions (pick ~3 to start):
- What are the top tasks this skill should handle?
- What are 2-5 example user prompts that should trigger it?
- What are the "done" outputs (files changed, commands run, artifact produced)?
- What constraints exist (stack, repo conventions, "don't touch X", safety concerns)?
- What's the failure mode to avoid (e.g., destructive commands, flaky edits)?

Stop when you can describe:
- triggers (what users say)
- scope boundaries (what it does / does not do)
- expected deliverables (what gets produced)

### 2) Plan the skill contents (what goes where)
For each example, decide what would be reusable next time:

- **SKILL.md**: the core workflow + decision points (the "recipe").
- **references/**: schemas, API notes, templates, company rules, long examples.
- **scripts/**: repeated code, fragile sequences, automation helpers.
- **assets/**: boilerplate projects, doc templates, images, fonts.

Heuristic:
- If it's long and consulted occasionally -> `references/`
- If it must be correct every time -> `scripts/`
- If it's copied and customized -> `assets/`

### 3) Implement the skill (files + structure)
Create a folder under `~/.codex/skills`:

```
<skill-name>/
  SKILL.md
  references/   (optional)
  scripts/      (optional)
  assets/       (optional)
```

Use `references/skill-skeleton.md` as a starting point if helpful.

### 4) Write a high-signal `description` (triggering)
The description should include:
- what the skill does (capability)
- when to use it (trigger phrases / situations)
- key variants if relevant (frameworks, environments)

Good pattern:
> "Do X. Use when user asks for X/Y/Z, especially when A/B constraints apply."

Avoid:
- vague ("helps with coding") or too narrow ("only for one exact phrasing")
- relying on body text for triggering (put trigger phrases/situations in `description`)

### 5) Write the SKILL.md body (actionable, not encyclopedic)
Guidelines:
- Use imperative form ("Do X", "Check Y").
- Prefer a checklist the agent can follow end-to-end.
- Include decision points ("If bun.lock exists... else...").
- Add a "Deliverable format" section that standardizes the final output.

If the skill supports multiple variants, keep selection guidance in SKILL.md and put variant-specific details in separate `references/<variant>.md` files.

### 6) Verify + iterate
Before considering it "done":
- Ensure the folder is discoverable (under `~/.codex/skills/<skill-name>/SKILL.md`).
- Ensure frontmatter is valid YAML; `name` and `description` are present, single-line, and within limits.
- Ensure every referenced file exists.
- Remove generated/example files you didn't actually need.

Then use it on a real request and tighten:
- missing steps -> add to checklist
- repeated code -> extract into `scripts/`
- long blocks -> move to `references/`
