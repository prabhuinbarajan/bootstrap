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
set -e
mkdir -p .data/
docker-machine ssh default sudo chmod a+rwx /var/run/docker.sock

base_command="docker-compose"
options="up -d --remove-orphans"

if [ $is_beta ]; then
    docker login -u $BETA_ACCESS_USERNAME -p $BETA_ACCESS_TOKEN quay.io
fi

export LISTENER_URL=$(curl -s $QUBE_HOST:4040/inspect/http | grep URL | sed 's#\\##g' | sed 's#window.common = JSON.parse("##g' | sed 's#");$##g' | jq -r '.Session.Tunnels.command_line.URL' | awk -F/ '{print $3}')
if [ -z $LISTENER_URL ];  then
    if [ $is_beta ]; then
        export LISTENER_URL=$NGROK_HOSTNAME
    else
        echo "ERROR: LISTENER URL is empty "
        exit 1
    fi
fi
echo "LISTENER URL is : $LISTENER_URL"
echo "starting docker-compose $base_command $files $options"
$base_command $files $options
