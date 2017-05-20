#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $DIR
export PATH=$PATH:$DIR/qubeship_home/bin

function show_help() {
cat << EOF
Usage: ${0##*/} [-h|--help] [--verbose] [--username githubusername] [--password githubpassword]  [--organization orgname] [--install-registry] [--install-target clustertype]
    --username              github username
    --password              github password
    --organization     login organization
    --install-target        clustertype [minikube, swarm]
    --install-registry      install a private docker registry
    --verbose               verbose mode.
EOF
}

function get_options() {
    while :; do
        case $1 in
            --install-target)   # Call a "show_help" function to display a synopsis, then exit.
                 if [ -n "$2" ]; then
                    install_target_cluster=true
                    clustertype=$2
                    if [ $clustertype != "minikube" ] ; then
                        printf 'ERROR: "--install-target" supports only [minikube]\n' >&2
                        exit 1
                    fi
                    shift
                else
                    printf 'ERROR: "--install-target" requires a non-empty option argument. choices [minikube]\n' >&2
                    exit 1
                fi
                ;;
            --username)   # Call a "show_help" function to display a synopsis, then exit.
                 if [ -n "$2" ]; then
                    github_username=$2
                    shift
                else
                    printf 'ERROR: "--username" requires github username\n' >&2
                    exit 1
                fi
                ;;
            --organization)   # Call a "show_help" function to display a synopsis, then exit.
                 if [ -n "$2" ]; then
                    SYSTEM_GITHUB_ORG=$2
                    shift
                else
                    printf 'ERROR: "--organization-name" requires valid organization\n' >&2
                    exit 1
                fi
                ;;
            --password)   # Call a "show_help" function to display a synopsis, then exit.
                 if [ -n "$2" ]; then
                    github_password=$2
                    shift
                else
                    read -s -p "github password: " github_password
                    if [ -z $github_password ];  then
                        printf 'ERROR: "--password" requires valid password\n' >&2
                    fi

                fi
                ;;
            --install-registry)       # Takes an option argument, ensuring it has been specified.
                registry=true
                ;;
            -h|-\?|--help)   # Call a "show_help" function to display a synopsis, then exit.
                show_help
                exit
                ;;
            -v|--verbose)
                verbose=true
                set -x
                ;;
            *)               # Default case: If no more options then break out of the loop.
                break
        esac

        shift
    done

}

