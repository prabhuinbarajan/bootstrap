#!/bin/bash

set -o allexport -x
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $DIR
export PATH=$PATH:$DIR/qubeship_home/bin

BETA_CONFIG_FILE=qubeship_home/config/beta.config
SCM_CONFIG_FILE=qubeship_home/config/scm.config
KUBE_CONFIG_FILE=$DIR/qubeship_home/endpoints/kube.config
REGISTRY_CONFIG_FILE=$DIR/qubeship_home/endpoints/registry.config
is_beta=
files="-f docker-compose.yaml"
is_osx=
if [ -f $BETA_CONFIG_FILE ] ; then
    source $BETA_CONFIG_FILE
fi

if [ ! -z $BETA_ACCESS_USERNAME ];  then
    is_beta="true"
    files="$files -f docker-compose-beta.yaml"
fi
DOCKER_INSTALL_TYPE="docker-machine"

if [ "$(uname)" == "Darwin" ]
then
  is_osx=true
  echo "DEBUG: detected OSX"
  if [ ! -z $(which base64) ]; then
        if [ ! -z $(docker info | grep -q moby) ]; then
           DOCKER_INSTALL_TYPE="mac"
        fi
        base64_bin="base64"
        base64_encode="$base64_bin"
        if [ ! -z "$(base64 --help | grep -i gnu )" ]; then
            echo "DEBUG: found gnu base 64 "
            base64_decode_opts="-d"
        else
            echo "DEBUG: found OSX base64"
            base64_decode_opts="-D"
        fi
        base64_decode="$base64_bin $base64_decode_opts"
  else
     echo "ERROR : base64 utility not found. this is usually a standard for OSX . exiting"
     exit 1
  fi

else
  echo "DEBUG: detected linux"
  base64_encode="base64"
  base64_decode="base64 -d"
fi
echo "INFO: base64 utility : $base64_encode $base64_decode"


function show_help() {
(>&2 cat << EOF
./install.sh --help
Usage: install.sh [-h|--help] [--verbose] [--username githubusername] [--password githubpassword]  [--organization orgname] [--github-host host ] [--install-registry] [--install-target target_cluster_type] [--install-sample-projects]
    --username              github username
    --password              github password. password can be provided in command line. if not, qubeship will prompt for password
    --organization          default github organization
    --github-host           github host [ format: http(s)://hostname ]
    --install-target        install a target endpoint of target_cluster_type [minikube, swarm] (**default true for beta users)
    --install-registry      install a private docker registry endpoint (**default true for beta users))
    --install-sample-projects install sample qubeship projects
    --verbose               verbose mode.
    --auto-pull             automatic pull of docker images from qubeship

a. --organization : the name of the Github organization of which Qubeship gives the admin access to every member. by default, Qubeship will give admin access to only you.
b. --github-host: if is not supplied, Qubeship will default the SCM to https://github.com. it should only be of the pattern https://hostname.
                    DO NOT specify context path. Qubeship will automatically remove the trailing slashes if specified
c. --install-registry : if you want to register  a default registry on installation , set to true.
                       Community Users:
                            Qubeship will expect  the registry details to be provided by user in  qubeship_home/endpoints/registry.config
                            Please refer to qubeship_home/endpoints/registry.config.template for example.
                       BETA Users: this is done automatically.
d. --install-target : if you want to register  a default target endpoint for deployment , set value to one of the supported cluster types
                       supported cluster values are : ["minikube"]
                       Community Users:
                         Qubeship will expect  the kubernetes config details to be provided by user in qubeship_home/endpoints/kube.config
                         Please refer to qubeship_home/endpoints/kube.config.template for example.
                       BETA Users:
                         this is done automatically.
e. --install-sample-projects install sample qubeship projects

EOF
)
exit 1

}

function url_ready() {
  url="$1"
  echo -n "Waiting for ${url} to become available."
  while [ ! "200" = "$(curl -sLiI -w "%{http_code}\\n" -o /dev/null ${url})" ]; do
    echo -n '.'
    sleep 1
  done
  echo 'ready.'
}

function get_options() {
    resolved_args="-t"
    while :; do
        case $1 in
            --install-target)   # Call a "show_help" function to display a synopsis, then exit.
                 if [ -n "$2" ]; then
                    install_target_cluster=true
                    target_cluster_type=$2
                    if [ $target_cluster_type != "minikube" ] ; then
                        printf 'ERROR: "--install-target" supports only [minikube]\n' >&2
                        exit 1
                    fi
                    shift
                else
                    printf 'ERROR: "--install-target" requires a non-empty option argument. choices [minikube]\n' >&2
                    exit 1
                fi
                echo "install_target_cluster=true"
                echo "target_cluster_type=minikube"
                resolved_args="$resolved_args --install-target $target_cluster_type"
                ;;
            --username)   # Call a "show_help" function to display a synopsis, then exit.
                 if [ -n "$2" ]; then
                    github_username=$2
                    shift
                else
                    printf 'ERROR: "--username" requires github username\n' >&2
                    echo "return_code=1"
                    exit 1
                fi
                echo "github_username=$github_username"
                resolved_args="$resolved_args --username $github_username"
                ;;
            --github-host)   # Call a "show_help" function to display a synopsis, then exit.
                 if [ -n "$2" ]; then
                    if [[ "$2" =~ ^http ]]; then
                        github_url=$(echo $2 | sed 's#/*$##')
                    else
                        echo 'ERROR: "--github-host" requires schema + github host name - default [https://github.com ]\n' >&2
                        echo "return_code=1"
                        exit 1
                    fi

                    shift
                else
                    printf 'ERROR: "--github-host" requires github host name [https://github.com ]\n' >&2
                    exit 1
                fi
                echo "github_url=$github_url"
                resolved_args="$resolved_args --github-host $github_url"
                ;;
            --organization)   # Call a "show_help" function to display a synopsis, then exit.
                 if [ -n "$2" ]; then
                    github_org=$2
                    shift
                else
                    printf 'ERROR: "--organization" requires valid organization\n' >&2
                    echo "return_code=1"
                    exit 1
                fi
                echo "github_org=$github_org"

                resolved_args="$resolved_args --organization $github_org"
                ;;
            --password)   # Call a "show_help" function to display a synopsis, then exit.
                 read_password=true
                 if [ -n "$2" ]; then
                    if [ "${2:0:2}" != "--" ]; then
                        github_password=$2
                        unset read_password
                        shift
                    fi
                 fi

                if [ $read_password ]; then
                    if [ -z "$github_password" ]; then
                        read -s -p "github password: " github_password
                    fi
                    if [ -z $github_password ];  then
                        printf 'ERROR: "--password" requires valid password\n' >&2
                    fi
                fi
                echo "github_password=$github_password"

                resolved_args="$resolved_args --password $github_password"
               ;;
            --install-registry)       # Takes an option argument, ensuring it has been specified.
                registry=true
                echo "registry=true"
                resolved_args="$resolved_args --install-registry"
                ;;
            --install-sample-projects)
                install_sample_projects=true
                echo "install_sample_projects=true"
                resolved_args="$resolved_args $1"
                ;;
            -h|-\?|--help)   # Call a "show_help" function to display a synopsis, then exit.
                echo return_code=1
                show_help
                ;;
            --auto-pull)
                auto_pull=true
                echo "auto_pull=true"
                resolved_args="$resolved_args $1"
                ;;
            -v|--verbose)
                verbose=true
                echo "verbose=true"
                resolved_args="$resolved_args $1"
                set -x
                ;;
            -t)
                ;;
            *)               # Default case: If no more options then break out of the loop.
                break
        esac

        shift
    done
    echo "return_code=0"
    echo 'resolved_args="'$resolved_args'"'

}

function update_endpoint_target_data() {
minikube_endpoint_id=$1
minikube_ip=$2

cat <<EOF > /tmp/ep_update.js
    use qubeship;
    try {
        db.endPoint.update(
            {_id: ObjectId("$minikube_endpoint_id")},
            {
                \$set:{
                    "endPoint" : "https://${minikube_ip}:8443"
                }
            }
        )
    }catch (e) {
     print (e);
    }
EOF

docker cp /tmp/ep_update.js $(docker-compose ps -q qube_mongodb):/tmp
docker-compose exec qube_mongodb sh -c "mongo < /tmp/ep_update.js"
}

export -f get_options
export -f update_endpoint_target_data
export -f url_ready
