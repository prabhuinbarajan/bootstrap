#!/bin/bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $DIR
set -o allexport
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

if [ -e $BETA_CONFIG_FILE ] ; then
    source $BETA_CONFIG_FILE
fi
if [ -e $DIR/.client_env ] ; then
    source $DIR/.client_env
fi
source .env

files="-f docker-compose.yaml"
if [ ! -z $BETA_ACCESS_USERNAME ];  then
    files="$files -f docker-compose-beta.yaml"
fi

docker-compose ps

wait_for_services=${1}
if [ ! -z $wait_for_services ]; then
    url_ready "${QUBE_BUILDER_URL}/jnlpJars/jenkins-cli.jar"
fi