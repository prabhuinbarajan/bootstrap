#!/bin/bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $DIR

output=`docker ps -a`
docker_client_status=$?

if [ $docker_client_status -ne 0 ]; then
    echo "ERROR : Docker doesnt seem to be running. is your docker running?"
    exit -1
fi

set -o allexport
if [ -e .client_env ]; then
    source .client_env
    source qubeship_home/config/qubeship.config
    rm -rf ./.client_env*
fi

docker-compose down -v

if [ !  -z "$BETA_ACCESS_USERNAME" ]; then
    docker-compose -f docker-compose-beta.yaml down -v
fi

rm -rf qubeship_home/builder/data/*
rm -rf qubeship_home/builder/opt/*
