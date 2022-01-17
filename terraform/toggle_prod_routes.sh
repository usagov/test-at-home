#!/bin/bash
#
# this script is used to map a new config, and unmap an old config using cf map-route
#
# USAGE: ./toggle_prod_routes.sh FEATURE_NAME_TO_ENABLE FEATURE_NAME_TO_DISABLE
#
# Example: ./toggle_prod_routes.sh prod-nosmarty prod

if [[ $# -ne 2 ]]; then
  echo "./toggle_prod_routes.sh <<FEATURE_NAME_TO_ENABLE>> <<FEATURE_NAME_TO_DISABLE>>"
  exit 1
fi

to_enable=$1
to_disable=$2

map_routes () {
  cf map-route "test_at_home-$to_enable-$1" route.covidtest.usa.gov
  cf unmap-route "test_at_home-$to_disable-$1" route.covidtest.usa.gov
  cf map-route "test_at_home-$to_enable-$1" $2
  cf unmap-route "test_at_home-$to_disable-$1" $2
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
