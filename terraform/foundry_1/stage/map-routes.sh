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
  cf unmap-route "test_at_home-stage-$app_number" app.wb.cloud.gov --hostname "test_at_home-stage-$app_number"
  cf map-route "test_at_home-stage-$app_number" staging-covidtest.usa.gov
  cf map-route "test_at_home-stage-$app_number" route.staging-covidtest.usa.gov
  cf map-route "test_at_home-stage-$app_number" west.staging-covidtest.usa.gov
  cf map-route "test_at_home-stage-$app_number" westb.staging-covidtest.usa.gov

  ((app_number++))
done
