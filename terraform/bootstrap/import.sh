#!/usr/bin/env bash

read -p "Are you sure you want to import terraform state (y/n)? " verify

if [[ $verify == "y" ]]; then
  echo "Importing bootstrap state"
  ./run.sh import cloudfoundry_service_instance.shared_config_bucket TKTK-guid
  ./run.sh import cloudfoundry_service_key.config_bucket_creds TKTK-guid
  ./run.sh plan
else
  echo "Not importing bootstrap state"
fi
