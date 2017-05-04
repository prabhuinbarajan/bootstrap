#!/bin/bash

services=$@
set -e -x
mkdir -p .data/
./login.sh
base_command="docker-compose"
options="up -d --remove-orphans"
files="-f docker-compose.yaml"
$base_command $files $options $services
