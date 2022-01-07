#!/usr/bin/env bash

cf target -o tts-usps-test-at-home -s tah-prod

# destroy service key
cf delete-service-key config-bootstrap-deployer space-deployer-key -f

# destroy service
cf delete-service config-bootstrap-deployer -f

rm secrets.auto.tfvars
