#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $DIR
export PATH=$PATH:$DIR/qubeship_home/bin

set -o allexport -x -e
BETA_CONFIG_FILE=qubeship_home/config/beta.config
SCM_CONFIG_FILE=qubeship_home/config/scm.config

if [ -e .client_env ]; then
    source $DIR/.client_env
    source ~/.qube_cli_profile
fi
if [ -e $SCM_CONFIG_FILE ] ; then
    source $SCM_CONFIG_FILE
fi
extra_args=""

if [ -e $BETA_CONFIG_FILE ] ; then
    source $BETA_CONFIG_FILE
    if [ ! -z $github_username ]; then
        extra_args="--username $github_username --password $github_password --organization-name $SYSTEM_GITHUB_ORG --skip-defaults"
    fi
fi
#extra_args=""
echo "Please login with your qube builder user"

qube auth login $extra_args
is_beta="false"
if [ ! -z $BETA_ACCESS_USERNAME ];  then
    is_beta="true"
fi
orgId=$(qube auth user-info --org | jq -r '.tenant.orgs[0].id')
sed "s/<SYSTEM_GITHUB_ORG>/${orgId}/g" load.js.template | sed  "s/beta_access/${is_beta}/g" > load.js


docker cp load.js $(docker-compose ps -q qube_mongodb):/tmp
docker-compose exec qube_mongodb sh -c "mongo < /tmp/load.js"
#read -n1 -r -p "Press any key to continue..." key
qube_service_configuration_complete="false"

access_token=$(vault read -field=access_token secret/resources/$TENANT/$ENV_TYPE/$ENV_ID/qubebuilder)
set +x
output_ready=$(curl -u qubebuilder:$access_token $QUBE_BUILDER_URL)
set +e -x
for i in `seq 1 3`;
do
    output=$(qube service postconfiguration | jq -r '.status')
    if [  "$output"=="Accepted"  ]; then
        qube_service_configuration_complete="true"
        break
    fi
    sleep 20
done
set -e 
if [ "$qube_service_configuration_complete" == "false" ]; then
    echo "error in qube service configuration. please rerun post configuration step ./postconfiguration.sh"
fi


#$DIR/run.sh

if [ ! -z $BETA_ACCESS_USERNAME ];  then
    registry_endpoint_id=58edb422238503000b74d7a6
    qube endpoints postcredential --endpoint-id $registry_endpoint_id \
        --credential-type username_password \
        --credential-data '{"username":"qubeship","password":"qubeship"}'
    echo "endpoint for default registry created successfully"
    echo "provisioning minikube"
    # ./provision_minikube.sh

fi
set +x
echo "Your Qubeship Installation is ready for use!!!!"
echo "Here are some useful urls!!!!"
echo "API: $API_URL_BASE"
echo "You can use your GITHUB credentials to login !!!!"
if [ ! -z $BETA_ACCESS_USERNAME ];  then
    echo "APP: $APP_URL"
fi
