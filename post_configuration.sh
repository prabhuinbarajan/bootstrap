#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $DIR
export PATH=$PATH:$DIR/qubeship_home/bin

set -o allexport
source $DIR/qube_common_functions.sh
eval $(get_options $@)
source .env

set -e
if [ $verbose ]; then
    set -x
fi

if [ -n $github_org ]; then
    SYSTEM_GITHUB_ORG=$github_org
fi

if [ -e .client_env ]; then
    source $DIR/.client_env
    source ~/.qube_cli_profile
fi

if [ -e $SCM_CONFIG_FILE ] ; then
    source $SCM_CONFIG_FILE
fi

if [ -e $BETA_CONFIG_FILE ] ; then
    source $BETA_CONFIG_FILE
fi
extra_args=""
if [ ! -z $github_username ]; then
    extra_args="--username $github_username --password $github_password --organization $SYSTEM_GITHUB_ORG --skip-defaults"
fi
#extra_args=""

qube auth login $extra_args
orgId=$(qube auth user-info --org | jq -r '.tenant.orgs[0].id')
sed "s/<SYSTEM_GITHUB_ORG>/${orgId}/g" load.js.template | sed  "s/beta_access/${is_beta:-false}/g" |  sed  "s/install_registry/${install_registry:-false}/g" | sed  "s/install_target_cluster/${install_target_cluster:-false}/g" > load.js


docker cp load.js $(docker-compose ps -q qube_mongodb 2>/dev/null):/tmp
docker-compose exec qube_mongodb sh -c "mongo < /tmp/load.js" 2>/dev/null

qube_service_configuration_complete="false"
RUN_VAULT_CMD="docker-compose exec qube-vault vault"
$RUN_VAULT_CMD auth $VAULT_TOKEN

access_token=$($RUN_VAULT_CMD read -field=access_token secret/resources/$TENANT/$ENV_TYPE/$ENV_ID/qubebuilder)
qubeuser=$($RUN_VAULT_CMD read -field=user secret/resources/$TENANT/$ENV_TYPE/$ENV_ID/qubebuilder)

set +e 
#if [ $verbose ]; then
#fi
docker-compose $files exec -T qube_builder bash -c 'rm -rf /home/jenkins/plugins/docker-plugin/WEB-INF/lib/jersey-apache-connector*.jar' 2>/dev/null
docker-compose $files exec -T qube_builder bash -c 'grep -Ril ApacheConnector /home/jenkins/plugins/docker-plugin/WEB-INF/ | xargs ls -lorth;' 2>/dev/null
CRUMB=$(curl -s --user $qubeuser:$access_token  http://${QUBE_HOST}:${QUBE_BUILDER_PORT}/crumbIssuer/api/xml?xpath=concat\(//crumbRequestField,%22:%22,//crumb\))
curl -X POST -H $CRUMB -u $qubeuser:$access_token -s http://${QUBE_HOST}:${QUBE_BUILDER_PORT}/restart
sleep 10
set +x
for i in `seq 1 5`;
do
    #output_ready=$(curl -u $qubeuser:$access_token -s "http://${QUBE_HOST}:${QUBE_BUILDER_PORT}/jnlpJars/jenkins-cli.jar")
    url_ready http://"${QUBE_HOST}:${QUBE_BUILDER_PORT}/jnlpJars/jenkins-cli.jar"

    output=$(qube service postconfiguration | jq -r '.status')
    if [  "$output"=="Accepted"  ]; then
        qube_service_configuration_complete="true"
        break
    fi
    sleep 20
done

if [ "$qube_service_configuration_complete" == "false" ]; then
    echo "error in qube service configuration. please rerun post configuration step ./postconfiguration.sh"
    exit 1
fi
if [ "$verbose" ]; then
    set -x
fi

#$DIR/run.sh
if [ "$is_beta" == "true" ];  then
    if [ "$install_target_cluster" == "true" ]; then
        if [ "$target_cluster_type" == "minikube" ]; then
            echo "provisioning minikube"
            ./provision_minikube.sh
         fi
    fi
fi
if [ "$install_registry" == "true" ];  then
    if [ -e $REGISTRY_CONFIG_FILE ]; then
        source $REGISTRY_CONFIG_FILE
        registry_endpoint_id=58edb422238503000b74d7a6
        registry_endpoint_url=$registry_url
        echo "updating registry"
        # update_endpoint_target_data $registry_endpoint_id $registry_endpoint_url
        endpoint_addl_info='{"account":"'${registry_prefix}'"}'
        qube endpoints update --endpoint-id $registry_endpoint_id --endpoint-url $registry_endpoint_url --additional-info $endpoint_addl_info --default --visibility=public
        data='{"username":"'${registry_userid}'","password":"'${registry_password}'"}'
        qube endpoints postcredential --endpoint-id $registry_endpoint_id \
            --credential-type username_password \
            --credential-data "${data}"
        echo "endpoint for default registry created successfully"
    fi
fi

if [ "$install_target_cluster" == "true" ]; then
    if [ -e $KUBE_CONFIG_FILE ]; then
        source $KUBE_CONFIG_FILE
        minikube_endpoint_id=58e3fad42a0603000b3e58a8
        echo "updating endpoint database"
        # update_endpoint_target_data $minikube_endpoint_id $kube_api_server
        endpoint_addl_info='{"namespace":"'${kube_namespace}'"}'
        qube endpoints update --endpoint-id $minikube_endpoint_id --endpoint-url $kube_api_server --additional-info $endpoint_addl_info --default --visibility=public
        data='{"token":"'${kube_token}'"}'
        qube endpoints postcredential --endpoint-id $minikube_endpoint_id \
            --credential-type access_token \
            --credential-data "${data}"
        echo "endpoint for minikube registered successfully"
    fi
fi


set +x
echo "Your Qubeship Installation is ready for use!!!!"
echo "Here are some useful urls!!!!"
echo "API: $API_URL_BASE"
echo "You can use your GITHUB credentials to login !!!!"
if [ ! -z $BETA_ACCESS_USERNAME ];  then
    echo "APP: $APP_URL"
fi
if [ "$install_sample_projects" == "true" ] ; then
    pguid=$(uuidgen)
    jguid=$(uuidgen)
    qube service postconfiguration
    echo "creating python sample project"
    qube service create --service-name "QubeFirstPythonProject" --repo-name "$pguid" --language=python
    echo "creating java sample project"
    qube service create --service-name "QubeFirstJavaProject" --repo-name "$jguid" --language=java
fi