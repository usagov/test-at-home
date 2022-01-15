#!/usr/bin/env bash

read -p "Are you sure you want to import terraform state (y/n)? " verify

if [[ $verify == "y" ]]; then
  echo "Importing bootstrap state"
  ./run.sh import module.s3.cloudfoundry_service_instance.bucket f6858d77-30ab-4017-a0d0-1ce0f2929458
  ./run.sh import module.s3.cloudfoundry_service_key.bucket_creds b51d3d35-630b-4414-b49a-7e141b4b9441
  ./run.sh plan
else
  echo "Not importing bootstrap state"
fi
