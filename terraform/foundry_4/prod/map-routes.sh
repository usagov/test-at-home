#!/bin/bash
#
# map all the apps in this foundation/environment
# usage: ./map-routes.sh

cf target
echo -n "Are you in the correct foundation? (y/n) "
read verify
echo

if [ "$verify" != "y" ];
then
  echo "Use switch_foundation.sh to switch foundations"
  exit 1
fi

echo "Mapping routes"

app_number=0
while [ $app_number -lt 10 ]
do
  cf unmap-route "test_at_home-prod-$app_number" app.eb.cloud.gov --hostname "test_at_home-prod-$app_number"
  cf map-route "test_at_home-prod-$app_number" route.covidtest.usa.gov
  cf map-route "test_at_home-prod-$app_number" eastb.covidtest.usa.gov

  ((app_number++))
done
