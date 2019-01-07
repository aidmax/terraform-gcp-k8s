#!/bin/bash
. ../.envrc
# To enable detailed log execute
# export PACKER_LOG=1
packer build -var zone=$CLOUDSDK_COMPUTE_ZONE -var project_id=$TF_ADMIN -var service_account_json=$TF_CREDS k8s.json
