#!/bin/bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $DIR

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
