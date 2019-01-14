#!/bin/bash

# To enable detailed log execute
# export PACKER_LOG=1

# Loading environment variables
set -e

source .envrc

packer validate \
    -var zone="$CLOUDSDK_COMPUTE_ZONE" \
    -var project_id="$TF_ADMIN" \
    -var service_account_json="$TF_CREDS" \
    packer/k8s.json

packer build \
    -var zone="$CLOUDSDK_COMPUTE_ZONE" \
    -var project_id="$TF_ADMIN" \
    -var service_account_json="$TF_CREDS" \
    packer/k8s.json

