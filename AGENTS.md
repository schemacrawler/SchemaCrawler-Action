# AGENTS.md — SchemaCrawler-Action

A Docker-based GitHub Actions action that runs the **SchemaCrawler CLI** inside a GitHub Actions workflow. It wraps the pre-built `schemacrawler/schemacrawler` Docker image with a shell script that reads configuration from the calling repository.

There are no Java sources or test suites in this project. The `pom.xml` contains version metadata only.

## Project Structure

```
action.yml          — GitHub Actions action definition (name, inputs, outputs, image reference)
Dockerfile          — extends schemacrawler/schemacrawler:{version}, replaces entrypoint script
schemacrawler.sh    — entrypoint: reads config, builds classpath, invokes SchemaCrawler CLI
```

## How the Action Works

1. **`action.yml`** specifies `using: docker` with `image: docker://schemacrawler/schemacrawler-action:{version}`.
2. **`schemacrawler.sh`** (the container entrypoint):
   - Reads `$GITHUB_WORKSPACE/.github/schemacrawler/schemacrawler.config.properties` for SchemaCrawler configuration.
   - Adds any JARs found in `$GITHUB_WORKSPACE/.github/schemacrawler/lib/` to the classpath (e.g., JDBC drivers, custom plugins).
   - Invokes the SchemaCrawler main class with arguments forwarded from the workflow `with:` block.
   - Writes the exit code to the `SC_EXIT_STATUS` environment variable, surfaced as the `exit_status` action output.
3. The container runs as `root` to have full read/write access to `$GITHUB_WORKSPACE`.

## Configuration in the Calling Repository

| Path | Purpose |
|------|---------|
| `.github/schemacrawler/schemacrawler.config.properties` | SchemaCrawler connection and option configuration |
| `.github/schemacrawler/lib/` | Additional JARs (JDBC drivers, plugins) added to the classpath |

## Release Process

Releases are triggered by pushing a **semantic version tag**:

```bash
git tag v17.11.0
git push origin v17.11.0
```

The release workflow:
1. Validates the semver tag format.
2. Creates a GitHub release with auto-generated release notes.
3. Builds a multi-platform Docker image (`linux/amd64`, `linux/arm64`) and pushes to Docker Hub with hierarchical version tags (`v17.11.0`, `17.11.0`, `17.10`, `17`).
4. Attaches SBOM and provenance attestation for supply chain security.

To update the SchemaCrawler version, change the `FROM` base image tag in `Dockerfile` and the image reference in `action.yml`, then push a new version tag.
