#!/bin/bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $DIR

output=`docker ps -a`
docker_client_status=$?

if [ $docker_client_status -ne 0 ]; then
    echo "ERROR : Docker doesnt seem to be running. is your docker running?"
    exit -1
fi
BETA_CONFIG_FILE=qubeship_home/config/beta.config
SCM_CONFIG_FILE=qubeship_home/config/scm.config
set -o allexport
if [ -e .client_env ]; then
    source .client_env
    rm -rf ./.client_env*
fi
if [ -e $SCM_CONFIG_FILE ] ; then
    source $SCM_CONFIG_FILE
fi
if [ -e $BETA_CONFIG_FILE ] ; then
    source $BETA_CONFIG_FILE
fi
docker-compose down -v

if [ !  -z "$BETA_ACCESS_USERNAME" ]; then
    docker-compose -f docker-compose-beta.yaml down -v
    rm -rf qubeship_home/config/scm.config

fi

rm -rf qubeship_home/builder/data/*
rm -rf qubeship_home/builder/opt/*
