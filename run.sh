#!/bin/bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $DIR

set -o allexport -x
if [ -e .client_env ]; then
    source .client_env
    source qubeship_home/config/qubeship.config
else
  ./login.sh
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
