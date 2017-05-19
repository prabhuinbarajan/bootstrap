#!/bin/bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $DIR
set -o allexport
source .env
set -e -x
export PATH=$PATH:$DIR/qubeship_home/bin

BETA_CONFIG_FILE=qubeship_home/config/beta.config
if [ -f $BETA_CONFIG_FILE ]; then
    echo "sourcing $BETA_CONFIG_FILE"
    source $BETA_CONFIG_FILE
else
    echo "INFO: $BETA_CONFIG_FILE not found. possibly running community edition"
    exit -1
fi


export github_username=$1
export github_password=$2
export github_url=$3
export github_org=$4
if [ -z "$github_username" ] ; then
    echo "Usage: ./qubeship_beta_install.sh <githubusername> [gitpassword | -p]  [githuburl] [githubsystemorg]"
    exit -1
fi

if [ "$github_password" == "-p" ];then
    read -s -p "password: " github_password
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
sleep 180

echo "running post configuration"
$DIR/post_configuration.sh

