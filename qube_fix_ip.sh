#!/bin/bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $DIR
set -o allexport +e +x

source $DIR/qube_common_functions.sh
source .env
export PATH=$PATH:$DIR/qubeship_home/bin

if [ "$(id -u)" != "0" ]; then
    echo "ERROR: this script needs to be run as root. You dont seem to have root privileges"
    echo "Usage: sudo  ${BASH_SOURCE[0]}"
    exit 1
fi
# copy .client_env.template to .client_env
output=`docker ps -a`
docker_client_status=$?
if [ $verbose ]; then
    set -x
fi
if [ $docker_client_status -ne 0 ]; then
    echo "ERROR : Docker doesnt seem to be running. is your docker running?"
    exit -1
fi


set  -e
if [ $is_osx ]; then
    if [ -z $DOCKER_HOST ]; then
        iface="lo0"
    elif [ $DOCKER_HOST != *"${DEFAULT_DOCKER_HOST}"* ] ; then
        iface="vboxnet0"
    fi

    if [ ! -z ${iface} ]; then
       ifconfig ${iface} alias $DEFAULT_DOCKER_HOST
       echo "INFO: DOCKER_HOST is not set to $DEFAULT_DOCKER_HOST. adding alias to $iface - ifconfig $iface alias $DEFAULT_DOCKER_HOST "
    fi
else
    echo "ERROR: non OSX platforms not currently supported"
    exit -1
fi
