#!/bin/bash
. ../.envrc

packer validate -var zone=$CLOUDSDK_COMPUTE_ZONE -var project_id=$TF_ADMIN -var service_account_json=$TF_CREDS k8s.json
