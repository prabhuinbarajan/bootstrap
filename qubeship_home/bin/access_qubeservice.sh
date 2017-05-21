#!/usr/bin/env bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $DIR/../..
export PATH=$DIR:$PATH
set +x -e

PROJECT=$(echo $1 | sed 's#/-service$##')
CONTEXT_PATH=$(echo $2 | sed 's#/\(.*\)$#\1#')
if [ -z $PROJECT ] ; then
    echo "Usage: ${BASH_SOURCE[0]} qube_project_name context_path"
    echo "Example: ${BASH_SOURCE[0]} myfirstjavaproject /api"
    exit 1
fi

echo $PROJECT

SERVICE=$PROJECT"-service"
CLUSTER_IP=$($DIR/kubectl get services -o jsonpath='{.items[?(@.metadata.name=="qubefirstpythonproject-service")].spec.clusterIP}')

echo "IP address of the $SERVICE : $CLUSTER_IP for $CONTEXT_PATH"
echo "curl http://$CLUSTER_IP/$CONTEXT_PATH"

curl http://$CLUSTER_IP/$CONTEXT_PATH