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
if [ -e $SCM_CONFIG_FILE ] ; then
    source $SCM_CONFIG_FILE
fi
if [ -e $BETA_CONFIG_FILE ] ; then
    source $BETA_CONFIG_FILE
fi
files="-f docker-compose.yaml"

if [ !  -z "$BETA_ACCESS_USERNAME" ]; then
    files="$files -f docker-compose-beta.yaml"
fi
docker-compose $files down -v 2>/dev/null
docker-compose $files down -v 2>/dev/null
#docker rm -f $(docker ps --filter name=bootstrap --format "{{lower .ID}}")
process_ids=$(docker-compose $files ps -q 2>/dev/null)
set +e
if [ ! -z  "$process_ids" ]; then
    echo "force remove: $process_ids"
    docker rm -f $process_ids
else
    echo "no containers alive in bootstrap"
fi
docker-compose $files down -v 2>/dev/null
docker volume ls | grep bootstrap_ | awk '{print $2}' | xargs docker volume rm
set -e
# delete .client_env
if [ -e .client_env ]; then
    source .client_env
    rm -rf ./.client_env*
fi
