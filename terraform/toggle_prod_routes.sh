#!/bin/bash
#
# this script is used to map a new config, and unmap an old config using cf map-route
#
# USAGE: ./toggle_prod_routes.sh -e FEATURE_NAME_TO_ENABLE -d FEATURE_NAME_TO_DISABLE
#
# Examples:
# ./toggle_prod_routes.sh -e prod-nosmarty -d prod
# ./toggle_prod_routes.sh -d prod
# ./toggle_prod_routes.sh -e prod


to_enable=""
to_disable=""
usage="./toggle_prod_routes.sh [-e <<FEATURE_NAME_TO_ENABLE>>] [-d <<FEATURE_NAME_TO_DISABLE>>]"

while getopts "he:d:" opt; do
  case "$opt" in
    e)
      to_enable=$OPTARG
      ;;
    d)
      to_disable=$OPTARG
      ;;
    *)
      echo $usage
      exit 1
      ;;
  esac
done

if [[ "$to_enable" = "" && "$to_disable" = "" ]]; then
  echo "You must supply at least one of -e or -d"
  echo $usage
  exit 1
fi

map_routes () {
  if [ "$to_enable" != "" ]; then
    cf map-route "test_at_home-$to_enable-$1" route.covidtest.usa.gov
    cf map-route "test_at_home-$to_enable-$1" $2
  fi
  if [ "$to_disable" != "" ]; then
    cf unmap-route "test_at_home-$to_disable-$1" route.covidtest.usa.gov
    cf unmap-route "test_at_home-$to_disable-$1" $2
  fi
}

./switch_foundation.sh 1
app_number=0
while [ $app_number -lt 10 ]
do
  map_routes $app_number "westb.covidtest.usa.gov"

  ((app_number++))
done

./switch_foundation.sh 2
app_number=0
while [ $app_number -lt 10 ]
do
  map_routes $app_number "westc.covidtest.usa.gov"

  ((app_number++))
done

./switch_foundation.sh 3
app_number=0
while [ $app_number -lt 10 ]
do
  map_routes $app_number "easta.covidtest.usa.gov"

  ((app_number++))
done

./switch_foundation.sh 4
app_number=0
while [ $app_number -lt 10 ]
do
  map_routes $app_number "eastb.covidtest.usa.gov"

  ((app_number++))
done
