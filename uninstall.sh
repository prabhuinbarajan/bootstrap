#!/bin/bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $DIR
uninstall_minikube=$1
uninstall_images=$2
output=`docker ps -a`
docker_client_status=$?

if [ "$(uname)" == "Darwin" ]
then
  is_osx=true
fi

if [ $docker_client_status -ne 0 ]; then
    echo "ERROR : Docker doesnt seem to be running. is your docker running?"
    exit -1
fi
BETA_CONFIG_FILE=qubeship_home/config/beta.config
SCM_CONFIG_FILE=qubeship_home/config/scm.config
set -o allexport


if [ -e $BETA_CONFIG_FILE ] ; then
    source $BETA_CONFIG_FILE
    rm -rf $SCM_CONFIG_FILE
else
    source $SCM_CONFIG_FILE
fi

files="-f docker-compose.yaml"

if [ !  -z "$BETA_ACCESS_USERNAME" ]; then
    files="$files -f docker-compose-beta.yaml"
fi
#docker rm -f $(docker ps --filter name=bootstrap --format "{{lower .ID}}")

process_ids=$(docker-compose $files ps -q 2>/dev/null)
set +e
if [ ! -z  "$process_ids" ]; then
    echo "force remove: $process_ids"
    docker rm -f $process_ids
else
    echo "no containers alive in bootstrap"
fi
stray_process_ids=$(docker ps -a | grep "qubeship/" | awk '{print $1}')
if [ ! -z  "$stray_process_ids" ]; then
    echo "force remove: $stray_process_ids"
    docker rm -f $stray_process_ids
fi
#docker-compose $files down -v 2>/dev/null
#docker volume ls | grep bootstrap_ | awk '{print $2}' | xargs docker volume rm
for volume in $(echo docker-registry-data  docker-registry-creds qubeship-mongo-data qubeship-postgres-data builder_home_data builder_home_opt vault_file vault_data qubeship-consul-data); do
   echo "INFO: attempting to remove $volume"
   volume_id=$(docker volume ls | grep $volume | awk '{print $2}')
   if [ ! -z $volume_id ]; then
        echo "INFO: volume removed $volume"
       docker volume rm $volume_id
   else
        echo "WARNING: volume not found $volume. perhaps already removed"
   fi
done
set -e
# delete .client_env
if [ -e .client_env ]; then
    rm -rf ./.client_env*
fi

if [ $is_osx ]; then
    set +e
    if [ ! -z "$uninstall_minikube" ]; then
        if [ "$uninstall_minikube" == "--remove-minikube" ]; then
            set -x
            echo "uninstalling minikube"
            rm -rf ~/.minikube/*
            rm -rf qubeship_home/endpoints/kube.config
            if [ ! -z "$(which VBoxManage)" ]; then
                VBoxManage controlvm minikube poweroff
                VBoxManage unregistervm minikube -delete
            fi
        fi
    fi
    set -e
else
    echo "uninstall minikube not supported"
fi

if [ ! -z "$uninstall_images" ]; then
    if [ "$uninstall_images" == "--remove-images" ]; then
        set -x
        images=$(docker images | grep "qubeship/" | awk '{print $3}')
        if [ ! -z  "$images" ]; then
            echo "force remove: $images"
            docker rmi -f $images
        fi
    fi
fi
