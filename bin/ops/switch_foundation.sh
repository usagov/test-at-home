#!/bin/bash
#
# switch the foundation we're logged into
# will attempt to use cf-targets if installed, and otherwise
# fall back to cf login
#
# usage: ./switch_foundation.sh [0-4]
# arg is number of the foundation, matching the terraform folders

set -e

case $1 in
  1)
    hostname="api.fr.wb.cloud.gov"
    target="tah-wb"
    ;;
  2)
    hostname="api.fr.wc.cloud.gov"
    target="tah-wc"
    ;;
  3)
    hostname="api.fr.ea.cloud.gov"
    target="tah-ea"
    ;;
  4)
    hostname="api.fr.eb.cloud.gov"
    target="tah-eb"
    ;;
  *)
    hostname="api.fr.cloud.gov"
    target="tah-wa"
    ;;
esac

cf_login () {
  cf login -a $hostname --sso
  exit 0;
}

# Check to see if they've already set up targets or not
cf targets --help > /dev/null 2>&1 || cf_login
cf set-target -f "$target" || cf_login

# output current target to verify which space you're in
cf target
