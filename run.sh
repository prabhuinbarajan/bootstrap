#!/bin/bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $DIR

set -o allexport -x
BETA_CONFIG_FILE=qubeship_home/config/beta.config
SCM_CONFIG_FILE=qubeship_home/config/scm.config

if [ -e .client_env ]; then
    source .client_env
else
  ./login.sh
fi
if [ -e $SCM_CONFIG_FILE ] ; then
    source $SCM_CONFIG_FILE
fi
if [ -e $BETA_CONFIG_FILE ] ; then
    source $BETA_CONFIG_FILE
fi
services=$@
set -e -x
mkdir -p .data/
docker-machine ssh default sudo chmod a+rwx /var/run/docker.sock

base_command="docker-compose"
options="up -d --remove-orphans"
files="-f docker-compose.yaml"

if [ !  -z "$BETA_ACCESS_USERNAME" ]; then
    docker login -u $BETA_ACCESS_USERNAME -p $BETA_ACCESS_TOKEN quay.io
    files="$files -f docker-compose-beta.yaml"
fi
echo "starting docker-compose $base_command $files $options $services"
$base_command $files $options $services
