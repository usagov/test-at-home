#!/bin/bash
#
# map all the apps in this foundation/environment
# usage: ./map-routes.sh

cf target
echo -n "Are you in the correct target? (y/n) "
read verify
echo

if [ "$verify" != "y" ];
then
  echo "Use switch_foundation.sh to switch foundations or cf t -s to switch spaces"
  exit 1
fi

echo "Mapping routes"

app_number=0
while [ $app_number -lt 10 ]
do
  cf map-route "test_at_home-prod-$app_number" covidtest.usa.gov
  cf map-route "test_at_home-prod-$app_number" route.covidtest.usa.gov
  cf map-route "test_at_home-prod-$app_number" west.covidtest.usa.gov
  cf map-route "test_at_home-prod-$app_number" westb.covidtest.usa.gov

  ((app_number++))
done
