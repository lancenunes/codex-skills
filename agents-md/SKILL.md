---
name: agents-md
description: Create or update root and nested AGENTS.md files that document directory-specific conventions and a feature map (feature -> paths, entrypoints, tests, docs). Use when the user asks for AGENTS.md, nested agent instructions, or a module/feature map.
---

# AGENTS.md builder

## Goal
Add lightweight, scoped guidance for an AI agent (and humans) by placing AGENTS.md files at key directory boundaries, including a "feature map" that points to the right code and docs fast.

## Inputs to ask for (if missing)
- Repo layout: where backend, frontend, docs, infra live.
- Top 5-15 user-facing features (names) and which component owns them (backend/frontend/both).
- Any hard rules (do not touch X, required commands, style rules).

## Where to put AGENTS.md (heuristics)
Create AGENTS.md at:
- repo root (global rules + map of sub-areas)
- each major component root (e.g., `backend/`, `frontend/`, `docs/`)
- any subdirectory that has different conventions, ownership, or high risk (payments, auth, data migrations)

Avoid placing AGENTS.md too deep unless there is a real boundary; too many files become noise.

## Workflow (checklist)
1) Inventory the repo
   - List top-level directories and build files (Gradle/Maven, Node/Next, docs site).
   - Identify the natural "component roots" and any critical submodules.
2) Draft root `AGENTS.md`
   - State global rules and tooling.
   - Add a short feature map and links to nested AGENTS.md files.
3) Draft nested AGENTS.md per component
   - Backend: how to run, test, migrate DB; key modules and entrypoints.
   - Frontend: how to run, build, test; env vars; key routes/areas.
   - Docs: docs structure, where to add ADRs/runbooks, how to preview/build docs.
4) Build the feature map
   - For each feature, include: owner, key paths, entrypoints, tests, docs.
   - Link to deeper scopes when needed (nested AGENTS.md or docs pages).
5) Verify consistency
   - Ensure guidance does not conflict between parent/child scopes.
   - Keep each AGENTS.md short and actionable; move long detail into docs under `docs/`.

## Templates
Use these templates:
- Root + nested AGENTS.md: `references/agents-template.md`
- Feature map table format: `references/feature-map-format.md`
- Suggested `docs/` layout (Spring + Next): `references/docs-structure.md`

