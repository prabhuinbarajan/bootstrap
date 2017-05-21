#!/usr/bin/env bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $DIR
set -x -e
export PATH=$PATH:$DIR/qubeship_home/bin

if [ "$(uname)" == "Darwin" ]
then
  echo "detected OSX"
    #brew cask install minikube
  minikube_url=https://storage.googleapis.com/minikube/releases/v0.19.0/minikube-darwin-amd64
  kubectl_url=http://storage.googleapis.com/kubernetes-release/release/v1.3.0/bin/darwin/amd64/kubectl
else
  echo "detected linux"
  if [ "$EUID" -ne 0 ]; then
     echo "Please run as root"
     exit -1;
  fi
  minikube_url=https://storage.googleapis.com/minikube/releases/v0.19.0/minikube-linux-amd64
  kubectl_url=http://storage.googleapis.com/kubernetes-release/release/v1.3.0/bin/linux/amd64/kubectl
fi

if [ -z $(which minikube) ]; then
    curl -sLo minikube $minikube_url && chmod +x minikube && mv minikube /usr/local/bin/
else
    echo "minikube already present"
fi
if [  -z $(which kubectl) ]; then
    curl -sLo kubectl $kubectl_url && chmod +x kubectl &&  mv kubectl /usr/local/bin/
else
    echo "kubectl already present"
fi

kubectl config use-context minikube
echo "confirming minikube is running"
if [ $(kubectl config  current-context) != "minikube" ]; then
    echo "ERROR: minikube configuration failed. endpoint configuration may not be successful"
    exit 0
fi

get_minikube_status() {
  vmstatus=$(minikube status | grep "minikubeVM:" | awk -F":" '{gsub(/ /,"",$2); print $2}' | tr '[:upper:]' '[:lower:]')
  kubestatus=$(minikube status | grep "localkube:" | awk -F":" '{gsub(/ /,"",$2); print $2}' | tr '[:upper:]' '[:lower:]')
}

get_minikube_status
if [ \( "$vmstatus" != "running" \) -o  \( "$kubestatus" != "running" \) ]; then
    minikube start
else
    echo "minikube already running"
fi
minikube_ip=$(minikube ip)
if [  "$minikube_ip" == "" ]; then
    echo "ERROR: unable to identify minikube ip. endpoint configuration may not be successful"
    exit 0
fi

# wait until minikube is running
timeout_count=0
while [ $timeout_count -lt 10 ]
do
  if [ \( "$vmstatus" != "running" \) -o  \( "$kubestatus" != "running" \) ]; then
    timeout_count=$(expr $timeout_count + 1)
    get_minikube_status
  else
    echo "minikube running"
    break
  fi
done

default_namespace=$(kubectl get namespaces  | grep default | awk '{print $1}')
if [ "$default_namespace" != "default" ]; then
    echo "ERROR: default namespace not found. endpoint configuration may not be successful"
    exit 0
fi

default_token=$(kubectl get serviceaccounts default -o yaml | grep -A1 secrets:  | tail -1 | awk '{print $3}')
if [  "$default_token" == "" ]; then
    echo "ERROR: default token not found. endpoint configuration may not be successful"
    exit 0
fi
api_server=$(kubectl config view  -o jsonpath='{.clusters[?(@.name == "minikube")].cluster.server }')
echo $api_server ":" $default_token

cat <<EOF > $DIR/qubeship_home/endpoints/kube.config
kube_api_server=$api_server
kube_token=$default_token
kube_namespace=default
EOF

