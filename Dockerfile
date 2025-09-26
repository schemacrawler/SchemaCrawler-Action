FROM schemacrawler/schemacrawler:v16.28.3

# Change user to 'root' to get access to the
# currently checked out project in $GITHUB_WORKSPACE
USER root

# Copy an updated SchemaCrawler shell script that reads from the
# currently checked out project in $GITHUB_WORKSPACE
# That is, read SchemaCrawler configuration from
# $GITHUB_WORKSPACE/.github/schemacrawler/schemacrawler.config.properties
# and additional jars from
# $GITHUB_WORKSPACE/.github/schemacrawler/lib/
COPY schemacrawler.sh /schemacrawler.sh

# Do not define an ENTRYPOINT, so that the entrypoint can be defined
# in the GitHub Actions workflow
