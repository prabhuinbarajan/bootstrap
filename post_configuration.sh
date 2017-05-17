#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $DIR

set -o allexport -x

if [ -e .client_env ]; then
    source .client_env
    source qubeship_home/config/qubeship.config
    source ~/.qube_cli_profile
fi

echo "Please login with your qube builder url"
qube auth login

orgId=$(qube auth user-info --org | grep -A2 "orgs\":" | tail -1  | sed "s#,##g"  | sed 's#"##g' | awk -F ":" '{ gsub(/ /, "", $2); print $2}')
./mongo_load.sh $orgId

qube service postconfiguration

$DIR/run.sh

if [ ! -z $BETA_ACCESS_USER_NAME ];  then
    registry_endpoint_id=58edb422238503000b74d7a6
    qube endpoints postcredential --endpoint-id $registry_endpoint_id \
        --credential-type username_password \
        --credential-data '{"username": "qubeship", "password":"qubeship"}'
    echo "endpoint for default registry created successfully"

fi