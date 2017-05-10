#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $DIR

set -o allexport -x

if [ -e .client_env ]; then
    source .client_env
    source qubeship_home/config/qubeship.config
    source ~/.qube_cli_profile
fi
./mongo_load.sh
echo "Please login with your qube builder url"
qube auth login
qube service postconfiguration

$DIR/run.sh
