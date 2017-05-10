#!/bin/bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $DIR
set -o allexport +e
source .env
set  -e
# copy .client_env.template to .client_env
if [ -z $DOCKER_HOST ]; then
    echo "ERROR : DOCKER_HOST environment variable has not been set. exiting"
    exit -1
fi
if [ -e .client_env ]; then
	echo 'ERROR : qubeship is already pre-configured.'
	exit 0
fi
QUBE_CONFIG_FILE=qubeship_home/config/qubeship.config

if [ ! -e $QUBE_CONFIG_FILE ]; then
	echo "ERROR : config file not found $QUBE_CONFIG_FILE"
	exit 0
fi

if [ ! -f /usr/local/bin/docker-compose ]; then
  curl -L "https://github.com/docker/compose/releases/download/1.9.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
  chmod +x /usr/local/bin/docker-compose
  docker-compose --version
fi


QUBE_CONSUL_SERVICE=qube-consul
QUBE_VAULT_SERVICE=qube-vault
LOG_FILE=qube_vault_log
QUBE_HOST=$(echo $DOCKER_HOST | awk '{ sub(/tcp:\/\//, ""); sub(/:.*/, ""); print $0}')
API_URL_BASE=http://$QUBE_HOST:$API_REGISTRY_PORT

consul_access_token=$(uuidgen | tr '[:upper:]' '[:lower:]')
cat qubeship_home/consul/data/consul.json.template | jq --arg acl_master_token "${consul_access_token}"  '.acl_master_token=$acl_master_token' > qubeship_home/consul/data/consul.json

# copy vault config.json, firebase.json, and consul.json to busybox
docker-compose up -d busybox
docker cp qubeship_home/vault/data/ "$(docker-compose ps -q busybox)":/vault/
docker cp qubeship_home/consul/data/consul.json "$(docker-compose ps -q busybox)":/consul/data/

########################## START: VAULT INITIALIZATION ##########################
# start qube-vault service
docker-compose up -d $QUBE_VAULT_SERVICE $QUBE_CONSUL_SERVICE


RUN_VAULT_CMD="docker-compose exec $QUBE_VAULT_SERVICE vault"

# acquire unseal_key and root token
$RUN_VAULT_CMD init -key-shares=1 -key-threshold=1 > $LOG_FILE
UNSEAL_KEY=$(cat $LOG_FILE | awk -F': ' 'NR==1{print $2}' | tr -d '\r')
VAULT_TOKEN=$(cat $LOG_FILE | awk -F': ' 'NR==2{print $2}' | tr -d '\r')

# unseal vault server
$RUN_VAULT_CMD unseal $UNSEAL_KEY
echo "sourcing $QUBE_CONFIG_FILE"

source $QUBE_CONFIG_FILE

echo "copying client template"
cp client_env.template .client_env
# put key and token to .client_env
sed -ibak "s#<unseal_key>#$UNSEAL_KEY#g" .client_env
sed -ibak "s/<vault_token>/$VAULT_TOKEN/g" .client_env
sed -ibak "s/<vault_addr>/$QUBE_HOST/g" .client_env
sed -ibak "s/<vault_port>/$VAULT_PORT/g" .client_env
sed -ibak "s/<consul_addr>/$QUBE_HOST/g" .client_env
sed -ibak "s/<consul_port>/$CONSUL_PORT/g" .client_env
sed -ibak "s#<api_url_base>#$API_URL_BASE#g" .client_env
#github api url adjustments
if [ ! -z "$GITHUB_ENTERPRISE_HOST" ]; then
    echo "GITHUB_API_URL=$GITHUB_ENTERPRISE_HOST/api/v3" >> .client_env
    echo "GITHUB_URL=$GITHUB_ENTERPRISE_HOST" >> .client_env
    echo "GITHUB_AUTH_URL=$GITHUB_ENTERPRISE_HOST/login/oauth/authorize" >> .client_env
    echo "GITHUB_TOKEN_URL=$GITHUB_ENTERPRISE_HOST/login/oauth/access_token" >> .client_env

fi



# export variables in .client_env
########################## START: CONSUL INITIALIZATION ##########################
# start qube-consul service


########################## END: CONSUL INITIALIZATION ##########################
sed -ibak "s#<conf_server_token>#${consul_access_token}#g" .client_env
echo "sourcing .client_env"
source .client_env


set -o allexport

# vault auth
$RUN_VAULT_CMD auth $VAULT_TOKEN

BASE_PATH="secret/resources"

# write data to vault
# tokens
$RUN_VAULT_CMD write $BASE_PATH/$TENANT/$ENV_TYPE/$ENV_ID/supertoken value=$VAULT_TOKEN
$RUN_VAULT_CMD write $BASE_PATH/$TENANT/$ENV_TYPE/$ENV_ID/usercreds_writer_token value=$VAULT_TOKEN
# firebase
$RUN_VAULT_CMD write $BASE_PATH/$TENANT/$ENV_TYPE/$ENV_ID/firebase_qubeship api_key=$FIREBASE_API_KEY service_key=@/vault/data/qubeship_firebase.json

$RUN_VAULT_CMD write $BASE_PATH/$TENANT/$ENV_TYPE/$ENV_ID/github_builder_client id=$GITHUB_BUILDER_CLIENTID secret=$GITHUB_BUILDER_SECRET
$RUN_VAULT_CMD write $BASE_PATH/$TENANT/$ENV_TYPE/$ENV_ID/github_cli_client id=$GITHUB_CLI_CLIENTID secret=$GITHUB_CLI_SECRET
$RUN_VAULT_CMD write $BASE_PATH/$TENANT/$ENV_TYPE/$ENV_ID/github_gui_client id=$GITHUB_GUI_CLIENTID secret=$GITHUB_GUI_SECRET


RUN_CONSUL_CMD="docker-compose exec $QUBE_CONSUL_SERVICE sh"
$RUN_CONSUL_CMD -c 'echo {\"X\":\"X\"}  | consul kv put qubeship/envs/'${ENV_TYPE}'/settings -'
$RUN_CONSUL_CMD -c 'echo {\"X\":\"X\"}  | consul kv put qubeship/envs/'${ENV_TYPE}/${ENV_ID}'/settings -'
########################## END: VAULT INITIALIZATION ##########################


# install qubeship cli
curl -sL http://cli.qubeship.io/install.sh?$(uuidgen) | bash -s $API_URL_BASE $CLI_IMAGE:$CLI_VERSION

