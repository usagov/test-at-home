#!/bin/bash
#
# switch the foundation we're logged into
#
# usage: ./switch_foundation.sh [0-4]
# arg is number of the foundation, matching the terraform folders

case $1 in
  1)
    hostname="api.fr.wb.cloud.gov"
    ;;
  2)
    hostname="api.fr.ea.cloud.gov"
    ;;
  *)
    hostname="api.fr.cloud.gov"
    ;;
esac

cf login -a $hostname --sso
