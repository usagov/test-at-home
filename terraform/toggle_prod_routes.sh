#!/bin/bash

usage="
$0: Map and/or unmap production routes from a set of apps in target foundations.

Usage:
  toggle_prod_routes.sh -h
  toggle_prod_routes.sh [-e <<FEATURE_NAME_TO_ENABLE>>] [-d <<FEATURE_NAME_TO_DISABLE>>] [-t <<TARGETS>>]

Options:
-h:                         show help and exit
-e FEATURE_NAME_TO_ENABLE:  app feature name to map, example: prod
-d FEATURE_NAME_TO_DISABLE: app feature name to unmap, example: prod-nosmarty
-s SPACE:                   space apps exist in
-c APP_COUNT:               number of apps to map/unmap
-t TARGETS:                 comma-delimited set of cf-targets to run against. You must use all active foundations or pain will follow

Notes:
* default space is prod
* deafult app count is 10
* default target list is tah-wb,tah-wc,tah-ea,tah-eb
* you must be a SpaceDeveloper in all of the target orgs
* this script relies on the cf-targets plugin

If the environment variable DRYRUN is set, then commands will be echoed rather than invoked. For example:
  DRYRUN=1 $0 -d prod-nosmarty
"

to_enable=""
to_disable=""
space="prod"
app_count=10
targets="tah-wb,tah-wc,tah-ea,tah-eb"

while getopts "he:d:s:c:t:" opt; do
  case "$opt" in
    e)
      to_enable=$OPTARG
      ;;
    d)
      to_disable=$OPTARG
      ;;
    s)
      space=$OPTARG
      ;;
    c)
      app_count=$OPTARG
      ;;
    t)
      targets=$OPTARG
      ;;
    *)
      echo "$usage"
      exit 1
      ;;
  esac
done

if [[ "$to_enable" = "" && "$to_disable" = "" ]]; then
  echo "You must supply at least one of -e or -d"
  echo "$usage"
  exit 1;
fi

targetlist="${targets//,/ }"

# Check to see if they've already set up targets or not
cf targets --help > /dev/null 2>&1 ||
    ( echo "ERROR: cf targets plugin not installed!

Install it with:
    cf install-plugin Targets -r CF-Community
" && exit 1 )

# Check for all of the targets
existingtargetlist=$(cf targets | cut -d ' ' -f 1)

difference=$(diff --left-column <( echo "$targetlist" | sed "s/\ /\n/g" | sort ) <( echo "$existingtargetlist" | sed "s/\ /\n/g" | sort ) | grep '^<' || true)

if [ -n "${difference}" ]; then
    echo "ERROR - These targets don't exist:"
    echo "$difference"

    cat << EOF

To set up a target:
    cf api ENDPOINT; cf login --sso
    cf t -o ORG
    cf save-target TARGET
EOF
    exit 1
fi

# If DRYRUN is set
if [ -n "${DRYRUN}" ]; then
    # Just echo the commands, don't run them.
    output="echo"
fi

function pushtarget() {
    startingtarget=$1
    cf save-target -f "$startingtarget" > /dev/null 2>&1
}

function poptarget() {
  cf set-target "$startingtarget"     > /dev/null 2>&1
  cf delete-target "$startingtarget"  > /dev/null 2>&1
}

pushtarget $(uuidgen)
trap poptarget exit

domain="covidtest.usa.gov"
if [ "$space" != "prod" ]; then
  domain="staging-covidtest.usa.gov"
fi

map_routes () {
  if [ "$to_enable" != "" ]; then
    $output cf map-route "test_at_home-$to_enable-$1" "route.$domain"
    $output cf map-route "test_at_home-$to_enable-$1" "$2.$domain"
  fi
  if [ "$to_disable" != "" ]; then
    $output cf unmap-route "test_at_home-$to_disable-$1" "route.$domain"
    $output cf unmap-route "test_at_home-$to_disable-$1" "$2.$domain"
  fi
}

for target in $targetlist; do
  cf set-target "$target"
  cf target -s "$space"

  endpoint=$(cf target | grep endpoint | cut -d / -f 3 | cut -d . -f 3)
  case "$endpoint" in
    wb)
      foundation_host="westb"
      ;;
    wc)
      foundation_host="westc"
      ;;
    ea)
      foundation_host="easta"
      ;;
    eb)
      foundation_host="eastb"
      ;;
    *)
      echo "Could not determine foundation host for target $target"
      exit 1;
      ;;
  esac

  app_number=0
  while [ $app_number -lt $app_count ]
  do
    map_routes $app_number $foundation_host

    ((app_number++))
  done
done

cf set-target "$startingtarget" > /dev/null 2>&1
cf delete-target "$startingtarget" > /dev/null 2>&1
