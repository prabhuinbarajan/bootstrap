#!/bin/bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $DIR
set -o allexport
function url_ready() {
  url="$1"
  echo -n "Waiting for ${url} to become available."
  while [ ! "200" = "$(curl -sLiI -w "%{http_code}\\n" -o /dev/null ${url})" ]; do
    echo -n '.'
    sleep 1
  done
  echo 'ready.'
}

source .env
set -e -x
export PATH=$PATH:$DIR/qubeship_home/bin

BETA_CONFIG_FILE=qubeship_home/config/beta.config
SCM_CONFIG_FILE=qubeship_home/config/scm.config

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


export github_username=${1:-$GITHUB_USERNAME}
export github_password=${2:-$GITHUB_PWD}
export github_url=${3:-$GITHUB_URL}
export github_org=${4:-$GITHUB_ORG}
if [ -z "$github_username" ] ; then
    echo "Usage: ./install.sh <githubusername> [gitpassword | -p]  [githuburl] [githubsystemorg]"
    exit -1
fi

if [ "$github_password" == "-p" ];then
    read -s -p "password: " github_password
fi
if [ -z "$github_password" ] ; then
    echo "ERROR: need github password. please refer to https://github.com/Qubeship/bootstrap/blob/master/OPEN_SOURCE_README.md#github-security"
    echo "Usage: ./install.sh <githubusername> [gitpassword | -p]  [githuburl] [githubsystemorg]"
    exit -1
fi

extraopts="--username $github_username --password $github_password"
if [ ! -z $github_org ]; then
 extraopts="$extraopts --github-org $github_org"
fi

if [ ! -z $github_url ]; then
 extraopts="$extraopts --github-host $github_url"
fi


echo "running preinstall scripts"
$DIR/init_qubeship.sh $extraopts


echo "starting qubeship server"
$DIR/run.sh
echo "waiting 180s until all qubeship services are up"
source $DIR/.client_env

url_ready "${QUBE_BUILDER_URL}/jnlpJars/jenkins-cli.jar"

echo "running post configuration"
$DIR/post_configuration.sh

