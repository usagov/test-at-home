#!/usr/bin/env bash

read -p "Are you sure you want to import terraform state (y/n)? " verify

if [[ $verify == "y" ]]; then
  echo "Importing bootstrap state"
  ./run.sh import module.s3.cloudfoundry_service_instance.bucket 42b05d6d-07ff-463a-90ca-374ad5e6f06a
  ./run.sh import module.s3.cloudfoundry_service_key.bucket_creds 72f775c4-2c83-4e32-976f-efc15907b4cb
  ./run.sh plan
else
  echo "Not importing bootstrap state"
fi
