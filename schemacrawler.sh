#!/usr/bin/env bash

banner()
{
  echo "+----------------------------------------------------+"
  printf "| %-50s |\n" "$@"  
  printf "| %-50s |\n" "`date`"
  echo "+----------------------------------------------------+"
}

banner "Starting SchemaCrawler Action for GitHub Actions job"
SC_DIR=/opt/schemacrawler
java -cp "$SC_DIR"/lib/*:"$GITHUB_WORKSPACE"/.github/schemacrawler/lib/*:"$GITHUB_WORKSPACE"/.github/schemacrawler/config schemacrawler.Main "$@"
EXIT_STATUS=$?
echo "::set-output name=exit_status::$EXIT_STATUS"
if $EXIT_STATUS ; then
  echo "SchemaCrawler GitHub Action job failed"
  exit $EXIT_STATUS
fi
