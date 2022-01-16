#!/usr/bin/env bash

read -p "Are you sure you want to import terraform state (y/n)? " verify

if [[ $verify == "y" ]]; then
  echo "Importing bootstrap state"
  ./run.sh import module.s3.cloudfoundry_service_instance.bucket f13fc659-fa22-4323-9a62-afcf33cebc50
  ./run.sh import module.s3.cloudfoundry_service_key.bucket_creds ee0678e4-3b69-4669-b8f0-b9523431efb3
  ./run.sh plan
else
  echo "Not importing bootstrap state"
fi
