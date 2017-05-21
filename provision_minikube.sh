#!/usr/bin/env bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $DIR
set -x -e
export PATH=$DIR/qubeship_home/bin:$PATH

if [ "$(uname)" == "Darwin" ]
then
  echo "detected OSX"
    #brew cask install minikube
  minikube_url=https://storage.googleapis.com/minikube/releases/v0.19.0/minikube-darwin-amd64
  kubectl_url=http://storage.googleapis.com/kubernetes-release/release/v1.6.0/bin/darwin/amd64/kubectl
  base64_decode="gbase64 -d"
else
  echo "detected linux"
  if [ "$EUID" -ne 0 ]; then
     echo "Please run as root"
     exit -1;
  fi
  minikube_url=https://storage.googleapis.com/minikube/releases/v0.19.0/minikube-linux-amd64
  kubectl_url=http://storage.googleapis.com/kubernetes-release/release/v1.6.0/bin/linux/amd64/kubectl
  base64_decode="base64 -d"
fi

if [ -z $(which minikube) ]; then
    curl -sLo minikube $minikube_url && chmod +x minikube && mv minikube /usr/local/bin/
else
    echo "minikube already present"
fi
if [  -z $(which kubectl | grep qubeship_home) ]; then
    curl -sLo kubectl $kubectl_url && chmod +x kubectl &&  mv kubectl $DIR/qubeship_home/bin
else
    echo "kubectl already present"
fi

kubectl config use-context minikube
echo "confirming minikube is running"
if [ $(kubectl config  current-context) != "minikube" ]; then
    echo "minikube context not found...attempting to start"
    minikube start
fi
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

for i in `seq 1 3`;
do
    DEFAULT_TOKEN_NAME=$(kubectl --namespace=kube-system get serviceaccount default -o jsonpath="{.secrets[0].name}")
    default_token=$(kubectl --namespace=kube-system get secret "$DEFAULT_TOKEN_NAME" -o go-template="{{.data.token}}" | $base64_decode)
    if [  "$default_token" == "" ]; then
        echo "ERROR: default token not found. Waiting for 20 secs"
        sleep 20
    else
        break
    fi
done

if [  "$default_token" == "" ]; then
    echo "ERROR: default token not found. endpoint configuration may not be successful"
    exit 0
fi
api_server=$(kubectl config view  -o jsonpath='{.clusters[?(@.name == "minikube")].cluster.server }')
echo $api_server ":" $default_token

# validate token
if [ ! "200" = "$(curl -ksw "%{http_code}\\n" -o /dev/null -H "Authorization: Bearer $default_token" $api_server/version)" ]; then
    echo 'token is not valid'
    exit 1
fi

cat <<EOF > $DIR/qubeship_home/endpoints/kube.config
kube_api_server=$api_server
kube_token=$default_token
kube_namespace=default
EOF
set +e
if [ -e $DIR/qubeship_home/endpoints/registry.config ]; then
    source $DIR/qubeship_home/endpoints/registry.config
    echo "adding registry $registry_url to minikube"
    registry_secret=$(kubectl get secret myregistrykey | awk '{print $1}' | grep myregistrykey)
    if [ -z "$registry_secret" ] ; then
        kubectl create secret docker-registry myregistrykey --docker-server=$registry_url --docker-username=$registry_userid --docker-password=$registry_password --docker-email=in@val.id
    else
        echo "secret $registry_secret already present. skipping secret creation"
    fi
    secret_present=$(kubectl get serviceaccounts default -o yaml | grep myregistrykey)
    if [ -z "$secret_present" ]; then
        kubectl get serviceaccounts default -o yaml > ./sa.yaml
cat << EOF >>sa.yaml
imagePullSecrets:
    - name: myregistrykey
EOF
        kubectl replace serviceaccount default -f ./sa.yaml
        rm ./sa.yaml
    else
        echo "registry imagepull secret already present in namespace"
    fi

fi
set -e