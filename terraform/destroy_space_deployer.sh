#!/usr/bin/env bash

if [[ $# -ne 2 ]]; then
  echo "./destroy_space_deployer.sh <<SPACE_NAME>> <<SERVICE_NAME>>"
  exit 1
fi

space=$1
service=$2

cf target -s $space

# destroy service key
cf delete-service-key $service space-deployer-key

# destroy service
cf delete-service $service
