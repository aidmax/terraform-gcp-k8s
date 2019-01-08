#!/usr/bin/env bash

set -e

# Extract "host","user" and "key_file" argument from the input into shell variables
eval "$(jq -r '@sh "HOST=\(.host) SSH_USER=\(.ssh_user) KEY=\(.key)"')"

# Fetch the join command
CMD=$(ssh -o BatchMode=yes -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -i "$KEY" \
    "$SSH_USER"@"$HOST" sudo kubeadm token create --print-join-command)

# Produce a JSON object containing the join command
jq -n --arg command "$CMD" '{"command":$command}'
