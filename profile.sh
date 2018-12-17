#!/bin/sh

mkdir -p /root/.aws
FILE="/root/.aws/config"

/bin/cat <<EOM >$FILE
[profile eb-cli]
aws_access_key_id=$1
aws_secret_access_key=$2
EOM