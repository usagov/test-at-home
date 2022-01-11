#!/usr/bin/env bash

read -p "Are you sure you want to import terraform state (y/n)? " verify

if [[ $verify == "y" ]]; then
  echo "Importing bootstrap state"
  ./run.sh import module.s3.cloudfoundry_service_instance.bucket fa15ed09-9879-4e56-8421-db092a5bac8f
  ./run.sh import module.s3.cloudfoundry_service_key.bucket_creds ee9363f8-47f2-4424-ba4e-ced6392177bf
  ./run.sh plan
else
  echo "Not importing bootstrap state"
fi
