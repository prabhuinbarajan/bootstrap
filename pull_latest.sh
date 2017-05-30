#!/bin/bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $DIR
set -o allexport -x -e
BETA_CONFIG_FILE=$DIR/qubeship_home/config/beta.config
files="-f docker-compose.yaml"
if [ -f $BETA_CONFIG_FILE ]; then
    echo "sourcing $BETA_CONFIG_FILE"
    source $BETA_CONFIG_FILE
    docker login -u $BETA_ACCESS_USERNAME -p $BETA_ACCESS_TOKEN quay.io
    files="$files -f docker-compose-beta.yaml"
fi
SECONDS=0
echo "${BASH_SOURCE[0]} started"
docker-compose $files pull
echo "${BASH_SOURCE[0]} completed  in $SECONDS"