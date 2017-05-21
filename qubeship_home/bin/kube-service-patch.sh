#!/usr/bin/env bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $DIR
source $DIR/../../qube_common_functions.sh

set -e
export PATH=$DIR/qubeship_home/bin:$PATH

if [ "$(id -u)" != "0" ]; then
    echo "this script needs to be run as root. You dont seem to have root privileges"
    echo "Usage: sudo  ${BASH_SOURCE[0]} \$(minikube ip)"
    exit 1
fi
ip=$1
if [ -z "$ip" ]; then
    echo "ERROR: route not specified"
	echo "Usage: sudo  ${BASH_SOURCE[0]} \$(minikube ip)"
    exit 1
fi
set -x
if [ "$(uname)" == "Darwin" ]
then
  echo "detected OSX"
  for i in `seq 2 254`;
    do
        echo "route -n add 10.0.0.$i/32 $ip"
        route -n add 10.0.0.$i/32 $ip
    done
else

  echo "detected linux"
  echo "ip route add 10.0.0.0/24 via $ip"
  ip route add 10.0.0.0/24 via $ip
fi

