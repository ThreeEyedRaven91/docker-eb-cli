#!/bin/sh

mkdir -p /root/.aws
FILE="/root/.aws/credentials"

/bin/cat <<EOM >$FILE
[default]
aws_access_key_id=$1
aws_secret_access_key=$2
EOM