#!/usr/bin/env bash

banner()
{
  echo "+----------------------------------------------------+"
  printf "| %-50s |\n" "$@"  
  printf "| %-50s |\n" "`date`"
  echo "+----------------------------------------------------+"
}

banner "SchemaCrawler Action for GitHub Actions"
SC_DIR=/opt/schemacrawler
java -cp "$SC_DIR"/lib/*:"$GITHUB_WORKSPACE"/.github/schemacrawler/lib/*:"$GITHUB_WORKSPACE"/.github/schemacrawler/config schemacrawler.Main "$@"
EXIT_STATUS=$?
echo "::set-output name=exit_status::$EXIT_STATUS"
