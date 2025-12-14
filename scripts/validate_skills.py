from __future__ import annotations

import re
import sys
from pathlib import Path

import yaml


FRONTMATTER_RE = re.compile(r"\A---\s*\n(.*?)\n---\s*\n", re.S)


def validate_skill_file(path: Path) -> list[str]:
    text = path.read_text(encoding="utf-8")
    match = FRONTMATTER_RE.match(text)
    if not match:
        return ["missing frontmatter block (--- ... --- at top of file)"]

    frontmatter = match.group(1)
    try:
        data = yaml.safe_load(frontmatter) or {}
    except Exception as exc:  # noqa: BLE001
        return [f"invalid YAML: {exc}"]

    errors: list[str] = []
    for key, limit in (("name", 100), ("description", 500)):
        value = data.get(key)
        if not isinstance(value, str) or not value.strip():
            errors.append(f"missing/empty {key}")
            continue
        if "\n" in value or "\r" in value:
            errors.append(f"{key} must be single-line")
        if len(value) > limit:
            errors.append(f"{key} too long ({len(value)}>{limit})")
    return errors


def main() -> int:
    repo_root = Path(__file__).resolve().parents[1]
    errors_found: list[str] = []

    for skill_dir in sorted([p for p in repo_root.iterdir() if p.is_dir()]):
        skill_md = skill_dir / "SKILL.md"
        if not skill_md.exists():
            continue
        errors = validate_skill_file(skill_md)
        for err in errors:
            errors_found.append(f"{skill_md.relative_to(repo_root)}: {err}")

    if errors_found:
        print("Skill validation errors detected:")
        for err in errors_found:
            print(f"- {err}")
        return 1

    print("OK: all SKILL.md files validated.")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())

