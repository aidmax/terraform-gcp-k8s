#!/bin/bash

set -e

declare TF_VAR_ssh_user

# Loading environment variables
source .envrc

mkdir -p "$HOME"/.kube_gcp
scp "$TF_VAR_ssh_user"@"$(terraform output k8s-master-ip)":.kube/config "$HOME"/.kube_gcp/config

KUBECONFIG="$HOME"/.kube_gcp/config kubectl config set-cluster kubernetes --server=https://"$(terraform output k8s-master-ip)":6443
export KUBECONFIG="$HOME"/.kube_gcp/config

