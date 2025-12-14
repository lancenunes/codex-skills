# AGENTS.md template (copy/paste)

## Root AGENTS.md (monorepo)

Use this at repo root when you have multiple subprojects/modules.

```markdown
# Agent instructions (scope: this directory and subdirectories)

## Scope and layout
- **This AGENTS.md applies to:** `<path/>` and below.
- **Key directories:**
  - ...

## Modules / subprojects
Use `references/module-map-format.md` for the table format.

## Cross-domain workflows
- **Frontend -> backend API**
  - API base URL / env vars: ...
  - Auth/session expectations (cookies, headers): ...
  - Contract location (OpenAPI/GraphQL) and how to update clients: ...
- **Local dev (run together)**
  - Start backend: ...
  - Start frontend: ...
  - Common gotchas (CORS, ports, proxies): ...

## Global conventions
- ...

## Do not
- Put tech-specific commands here (keep them in module AGENTS.md).
- ...

## Links to module instructions
- `<module-path>/AGENTS.md`
- ...
```

## Module AGENTS.md (component-specific)

Use this inside each module/component root (backend/frontend/docs/etc.). This is where tech-specific instructions belong.

```markdown
# Agent instructions (scope: this directory and subdirectories)

## Scope and layout
- **This AGENTS.md applies to:** `<path/>` and below.
- **Owner:** `<team>`
- **Key directories:**
  - ...

## Commands (use what this repo uses)
- **Install:** ...
- **Dev:** ...
- **Test:** ...
- **Build:** ...

## Feature map (optional)
Use `references/feature-map-format.md` for the table format.

## Conventions
- ...

## Common pitfalls
- ...

## Do not
- ...
```
