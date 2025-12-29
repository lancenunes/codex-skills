# Examples

## Input snippet (from sessions/articles/YYYY-MM-DD.md)
User: Asked for a new skill to generate blog posts from session logs.
Codex: Initialized a new skill folder and drafted the workflow.
Steps / Artifacts: Created `skills/sessions-to-blog/SKILL.md` and references.
Progress: Skill scaffold created.
Decisions: Skill name set to `sessions-to-blog`.
Open concerns: Output path and language preference.

## Output skeleton (blog post)
---
# Add required fields per project MDX standard
title: Building a Sessions to Blog Skill
---

# Building a Sessions to Blog Skill

A short daily recap of how we turned session logs into a reusable blog workflow.

## Highlights
- Defined the core workflow for converting session logs to posts
- Added style and linking rules as reusable references
- Flagged open questions about output location and language

## What We Did
We initialized a new skill directory and created the core instructions for drafting posts from session logs. We also captured a style guide and linking rules so future posts stay consistent.

## Decisions
- Skill name set to `sessions-to-blog`

## Open Questions
- Where should the blog posts be written (target path)?
- What should be the default language if logs are mixed?

## Next Steps
- Confirm output path and language defaults
- Package the skill if distribution is needed

## Sources
- `sessions/articles/YYYY-MM-DD.md`
