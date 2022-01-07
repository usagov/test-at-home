#!/usr/bin/env bash

if [[ $# -ne 2 ]]; then
  echo "./create_space_deployer.sh <<SPACE_NAME>> <<SERVICE_NAME>>"
  exit 1
fi

space=$1
service=$2

cf target -s $space

# create space deployer service
cf create-service cloud-gov-service-account space-deployer $service

# create service key
cf create-service-key $service space-deployer-key

# output service key to stdout
cf service-key $service space-deployer-key
