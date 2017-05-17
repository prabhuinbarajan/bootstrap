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
if [ ! -z $BETA_ACCESS_USER_NAME ];  then
    qube endpoints create --category production --endpoint-url https://registry.beta.qubeship.io/v2 \
    --name default-registry --provider generic --type registry --default > /tmp/registry-ep.json
    registry_endpoint_id=$(cat /tmp/registry-ep.json | grep "\"id\":" | sed "s#,##g"  | sed 's#"##g' | awk -F ":" '{ gsub(/ /, "", $2); print $2}')
    qube endpoints postcredential --endpoint-id $registry_endpoint_id \
        --credential-type username_password \
        --credential-data '{"username": "qubeship", "password":"qubeship"}'
    echo "endpoint for default registry created successfully" && rm -rf /tmp/registry-ep.json

    RUN_CONSUL_CMD="docker-compose exec $QUBE_CONSUL_SERVICE sh"
    $RUN_CONSUL_CMD -c 'echo {\"DEFAULT_ENDPOINT_IDS\":\"$registry_endpoint_id\"}  | consul kv put qubeship/envs/'${ENV_TYPE}/${ENV_ID}'/settings -'

fi

$DIR/run.sh
