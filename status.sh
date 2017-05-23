#!/bin/bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $DIR
set -o allexport
export PATH=$DIR/qubeship_home/bin:$PATH

function url_ready() {
  url="$1"
  echo -n "Waiting for ${url} to become available."
  while [ ! "200" = "$(curl -sLiI -w "%{http_code}\\n" -o /dev/null ${url})" ]; do
    echo -n '.'
    sleep 1
  done
  echo 'ready.'
}

BETA_CONFIG_FILE=qubeship_home/config/beta.config
SCM_CONFIG_FILE=qubeship_home/config/scm.config

if [ -e $BETA_CONFIG_FILE ] ; then
    source $BETA_CONFIG_FILE
fi
if [ -e $DIR/.client_env ] ; then
    source $DIR/.client_env
fi
if [ -e $SCM_CONFIG_FILE ] ; then
    source $SCM_CONFIG_FILE
fi
source .env

files="-f docker-compose.yaml"
if [ ! -z $BETA_ACCESS_USERNAME ];  then
    files="$files -f docker-compose-beta.yaml"
fi
echo "docker-compose  $files ps"
docker-compose  $files ps


wait_for_services=${1}
if [ ! -z $wait_for_services ]; then
    url_ready http://"${QUBE_HOST}:${QUBE_BUILDER_PORT}/jnlpJars/jenkins-cli.jar"
    url_ready "http://$QUBE_HOST:${QUBESERVICE_API_PORT}$QUBESERVICE_API_PATH/version"

fi

echo "collecting qubeship service status"
export COMPANY=test
api_auth_swagger=$(docker exec -it $(docker-compose ps -q api_registry) curl http://api_auth:$AUTH_API_PORT/specs.json | jq -r '.swagger')  
api_auth_version=$(docker exec -it $(docker-compose ps -q api_registry) curl http://api_auth:${AUTH_API_PORT}$AUTH_API_PATH/version | jq -r '.version')
api_endpoints_swagger=$(docker exec -it $(docker-compose ps -q api_registry) curl http://api_endpoints:${ENDPOINTS_API_PORT}${ENDPOINTS_API_SPEC_PATH}| jq -r '.swagger') 
api_endpoints_version=$(docker exec -it $(docker-compose ps -q api_registry) curl http://api_endpoints:${ENDPOINTS_API_PORT}${ENDPOINTS_API_PATH}/version| jq -r '.version')

api_project_swagger=$(docker exec -it $(docker-compose ps -q api_registry) curl http://api_project:${PROJECT_API_PORT}${PROJECT_API_SPEC_PATH}| jq -r '.swagger') 
api_project_version=$(docker exec -it $(docker-compose ps -q api_registry) curl http://api_project:${PROJECT_API_PORT}${PROJECT_API_PATH}/version| jq -r '.version')

api_opinions_swagger=$(docker exec -it $(docker-compose ps -q api_registry) curl http://api_opinions:${OPINIONS_API_PORT}/specs.json| jq -r '.swagger') 
api_opinions_version=$(docker exec -it $(docker-compose ps -q api_registry) curl http://api_opinions:${OPINIONS_API_PORT}${OPINIONS_API_PATH}/version| jq -r '.version')

api_pipeline_swagger=$(docker exec -it $(docker-compose ps -q api_registry) curl http://api_pipeline:${PIPELINE_API_PORT}/specs.json| jq -r '.swagger') 
api_pipeline_version=$(docker exec -it $(docker-compose ps -q api_registry) curl http://api_pipeline:${PIPELINE_API_PORT}${PIPELINE_API_PATH}/version| jq -r '.version')

api_pipeline_v2_swagger=$(docker exec -it $(docker-compose ps -q api_registry) curl http://api_pipeline_v2:${ARTIFACTS_API_PORT}/specs.json| jq -r '.swagger') 
api_pipeline_v2_version=$(docker exec -it $(docker-compose ps -q api_registry) curl http://api_pipeline_v2:${ARTIFACTS_API_PORT}${ARTIFACTS_API_PATH}/version | jq -r '.version')

api_tenant_swagger="not supported"
api_tenant_version=$(docker logs  $(docker-compose ps -q api_tenant) | grep "Running on http://0.0.0.0:${TENANT_API_PORT}" | awk '{ if ( $0 != "" )  {print "stable" }}')

api_toolchains_swagger=$(docker exec -it $(docker-compose ps -q api_registry) curl http://api_toolchains:${TOOLCHAIN_API_PORT}/specs.json| jq -r '.swagger') 
api_toolchains_version=$(docker exec -it $(docker-compose ps -q api_registry) curl http://api_toolchains:${TOOLCHAIN_API_PORT}${TOOLCHAIN_API_PATH}/version| jq -r '.version')


api_qubeservice_swagger=$(docker exec -it $(docker-compose ps -q api_registry) curl http://api_qubeservice:$QUBESERVICE_API_PORT/specs.json| jq -r '.swagger') 
api_qubeservice_version=$(curl -s http://$QUBE_HOST:${QUBESERVICE_API_PORT}$QUBESERVICE_API_PATH/version| jq -r '.version')

docker_registry_swagger="not supported"
docker_registry_version=$(docker login registry.beta.qubeship.io:5001 -u qubeship -p qubeship | awk '{ if ( $0 == "Login Succeeded" )  {print "stable" }}')

echo "qubeship service status"
echo "-----------------------"

for key in $(echo api_auth api_endpoints api_project api_opinions api_pipeline api_pipeline_v2 api_tenant api_toolchains api_qubeservice docker_registry); do
    swagger_key=$key"_swagger"
    version_key=$key"_version"
    swagger_value=${!swagger_key}
    version_value=${!version_key}

    if [ -z "$swagger_value" ]; then
        echo "ERROR : service $key may have an issue. $swagger_key returned $swagger_value "
    else
        echo "$swagger_key : $swagger_value"
    fi
    if [ -z "$version_value" ]; then
        echo "WARN : service $key may have an issue. $version_key returned $version_value "
    else
        echo "$version_key : $version_value"
    fi
done

echo "-----------------------"
