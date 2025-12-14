# Node/TypeScript upgrade playbook

## Choose the package manager
- If `pnpm-lock.yaml` exists: use `pnpm`.
- If `yarn.lock` exists: use `yarn`.
- If `package-lock.json` exists: use `npm`.
- If `bun.lock` exists: use `bun`.

## Common commands (pick what fits the repo)
- List outdated deps: `npm outdated` / `pnpm outdated` / `yarn outdated`
- Upgrade a single dep: `npm i <pkg>@<ver>` / `pnpm add <pkg>@<ver>` / `yarn add <pkg>@<ver>`
- Upgrade dev dep: `npm i -D <pkg>@<ver>` / `pnpm add -D <pkg>@<ver>` / `yarn add -D <pkg>@<ver>`
- Run tests/build: `npm test` / `pnpm test` / `yarn test` and `npm run build` / `pnpm build` / `yarn build`

## Notes
- Prefer updating types packages together with their runtime dep.
- For majors, search the repo for removed APIs and follow upstream migration notes.

