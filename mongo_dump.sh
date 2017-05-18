#!/bin/bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $DIR
mongo_pod=$(kubectl get pods --namespace platform | grep mongo | awk '{print $1}')
kubectl exec -it $(kubectl get pods --namespace platform | grep mongo | awk '{print $1}') --namespace platform mongo  < query_mongo.js | tail -n +4 | grep -v "switched to db" | egrep -v "^>|^bye"   > load.js
