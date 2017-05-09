#!/bin/bash
set -e -x
if [ -z "$(which mongo)" ]; then
     echo "Please install mongo with homebrew mongo" 
     exit -1;
fi
MONGO_HOST=${1:-$(docker-machine ip)}
sed -ibak 's/"orgId" : "150e18f6-0165-34ad-ad30-8577b03eadb4/"orgId" : "39928fd4-b86a-36bf-8a06-20932b88ba81/g' load.js
mongo $MONGO_HOST:27017 < load.js

if [ -e load.js.private ]; then
sed -ibak 's/"orgId" : "150e18f6-0165-34ad-ad30-8577b03eadb4/"orgId" : "39928fd4-b86a-36bf-8a06-20932b88ba81/g' load.js.private
mongo $MONGO_HOST:27017 < load.js.private
fi