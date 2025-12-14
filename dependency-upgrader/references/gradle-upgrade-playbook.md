# Gradle/Java/Kotlin upgrade playbook

## Identify where versions live
- `build.gradle(.kts)` (plugins + deps)
- `gradle/libs.versions.toml` (version catalogs)
- `gradle/wrapper/gradle-wrapper.properties` (Gradle wrapper)

## Common commands (pick what fits the repo)
- Run tests: `./gradlew test` (or the repo's task)
- Build: `./gradlew build`
- Update Gradle wrapper: `./gradlew wrapper --gradle-version <ver>`

## Spring-specific notes
- Spring Boot upgrades can require:
  - Java version alignment
  - dependency BOM alignment
  - config key changes
  - actuator/security behavior changes

## Notes
- Prefer one major bump at a time (e.g., Kotlin, then Boot, then plugins).
- Keep version changes centralized (catalog/BOM) when the repo uses them.

