#!/bin/bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $DIR

set -o allexport
source $DIR/qube_common_functions.sh
eval $(get_options $@)
echo $resolved_args

if [ $verbose ]; then
    set -x
fi

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

docker-machine ssh default sudo chmod a+rwx /var/run/docker.sock
set -e

base_command="docker-compose"
options="up -d --remove-orphans"

if [ $is_beta ]; then
    docker login -u $BETA_ACCESS_USERNAME -p $BETA_ACCESS_TOKEN quay.io
fi


if [ $is_beta ]; then
    export LISTENER_URL=$NGROK_HOSTNAME
fi
echo "LISTENER URL is : $LISTENER_URL"
echo "starting docker-compose $base_command $files $options"
$base_command $files $options
