#!/bin/bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $DIR
set -o allexport +x
source $DIR/qube_common_functions.sh
set +x
eval $(get_options $@)

if [ "${return_code}" -eq 1 ]; then
    exit $return_code
fi
if [ "${no_args:-0}" -eq 1 ]; then
    show_help;
    exit 1
fi
if [ ! -z "$DOCKER_INSTALL_TYPE" ]; then
    if [ "$DOCKER_INSTALL_TYPE" == "mac" ]; then
        echo "ERROR: Qubeship installation on docker for mac is still on roadmap. please install docker toolbox instead"
        #exit 1
    fi
fi
source .env
touch .client_env
set -e
if [ $verbose ]; then
    set -x
fi
export PATH=$PATH:$DIR/qubeship_home/bin
SECONDS=0
echo "install.sh: $( date ) : starting qubeship install"


if [ -f $BETA_CONFIG_FILE ]; then
    echo "sourcing $BETA_CONFIG_FILE"
    source $BETA_CONFIG_FILE
else
    echo "INFO: running community edition"
    if [ ! -f $SCM_CONFIG_FILE ]; then
        echo "ERROR: $SCM_CONFIG_FILE not found. please create this file. refer to https://github.com/Qubeship/bootstrap/blob/master/OPEN_SOURCE_README.md"
        exit -1
    fi
    for key in $(echo GITHUB_CLI_CLIENTID GITHUB_CLI_SECRET GITHUB_BUILDER_CLIENTID GITHUB_CLI_SECRET); do
        value=${!key}
        echo $key $value
        if [ -z $value ]; then
            echo "ERROR $key not defined in $SCM_CONFIG_FILE. refer to https://github.com/Qubeship/bootstrap/blob/master/OPEN_SOURCE_README.md"
            exit -1
        fi
    done
    source $SCM_CONFIG_FILE
fi

if [ $is_beta ];  then
    docker login -u $BETA_ACCESS_USERNAME -p $BETA_ACCESS_TOKEN quay.io
    if [ $? -ne 0 ]; then
        echo "ERROR : failed to do docker login. please check your docker installation"
        exit 1
    fi
fi

if [ $auto_pull ] ; then
    docker-compose $files pull
fi


if [ -z "$(which curl)" ]; then
    echo "ERROR: missing curl utility. please install and try again"
    exit -1
fi
if [ -z "$github_username" ] ; then
    echo "ERROR: missing username"
    show_help
    exit -1
fi

if [ -z "$github_password" ] ; then
    echo "ERROR: missing password"
    show_help
    exit -1
fi

echo "install.sh: $( date ) : running preinstall scripts"
$DIR/init_qubeship.sh $resolved_args

echo "install.sh: $( date ) :starting qubeship server"
$DIR/run.sh

echo "install.sh: $( date ) :waiting until all qubeship services are up"
./status.sh "true"

echo "install.sh: $( date ) :running post configuration"
$DIR/post_configuration.sh $resolved_args
echo "install.sh: $( date ) :completed qubeship installation in $SECONDS seconds"
