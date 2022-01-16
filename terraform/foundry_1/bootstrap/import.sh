#!/usr/bin/env bash

read -p "Are you sure you want to import terraform state (y/n)? " verify

if [[ $verify == "y" ]]; then
  echo "Importing bootstrap state"
  ./run.sh import module.s3.cloudfoundry_service_instance.bucket 6e44ba70-f4b8-40be-a23c-1a8042250bdb
  ./run.sh import module.s3.cloudfoundry_service_key.bucket_creds ade8c5f7-b447-4b2d-8288-7546b93d17d6
  ./run.sh plan
else
  echo "Not importing bootstrap state"
fi
