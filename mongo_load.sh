#!/bin/bash
set -e -x
orgId=${1:-"39928fd4-b86a-36bf-8a06-20932b88ba81"}
sed -ibak 's/"orgId" : "150e18f6-0165-34ad-ad30-8577b03eadb4/"orgId" : "$orgId/g' load.js
mongo_instance=$(docker-compose ps  | grep mongo | awk '{print $1}')
docker cp load.js $mongo_instance:/tmp

docker-compose exec qube_mongodb sh -c "mongo < /tmp/load.js"


if [ -e load.js.private ]; then
sed -ibak 's/"orgId" : "150e18f6-0165-34ad-ad30-8577b03eadb4/"orgId" : "$orgId/g' load.js.private
docker cp load.js.private $mongo_instance:/tmp
docker-compose exec qube_mongodb sh -c "mongo < /tmp/load.js.private"
fi
set x