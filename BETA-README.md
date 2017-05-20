# Install Qubeship Beta

## Prerequisites
1. Docker Runtime v1.11 and above
2. Docker-compose
3. [Docker-machine](https://github.com/docker/machine/releases)
3. Text Editor
4. Curl 
5. A valid and running docker host.  Docker Host should be up and running.

You should be able to run the following command and get a valid output:
```
    docker ps -a 
    CONTAINER ID        IMAGE                                                             COMMAND                  CREATED             STATUS                  PORTS                                                                      NAMES
```
----
## Install

1. Clone the repo
```
git clone https://github.com/Qubeship/bootstrap
cd bootstrap ; git checkout community_beta 
```


2. copy the beta.config file to qubeship_home/config

3.  Run the beta install script
```
  ./qubeship_beta_install.sh --username <githubusername> --password [gitpassword]  [--organization github_organization] [--github-host githubsystemorg]
```

At the end of installation , you should see a message like this
```
Your Qubeship Installation is ready for use!!!!
Here are some useful urls!!!!
API: http://192.168.99.100:9080
You can use your GITHUB credentials to login !!!!
APP: http://192.168.99.100:7000
```

4. login to the qubeship app url


### Help

1. ./install.sh --help
```
./install.sh --help
Usage: install.sh [-h|--help] [--verbose] [--username githubusername] [--password githubpassword]  [--organization orgname] [--github-host host ] [--install-registry] [--install-target target_cluster_type]
    --username              github username
    --password              github password. password can be provided in command line. if not, qubeship will prompt for password
    --organization          default github organization
    --github-host           github host [ format: http(s)://hostname ]
    --install-target        install a target endpoint of target_cluster_type [minikube, swarm] (**default true for beta users)
    --install-registry      install a private docker registry endpoint (**default true for beta users))
    --verbose               verbose mode.
    --auto-pull             automatic pull of docker images from qubeship

a. -- organization : if it is not specified, Qubeship will take the users personal organization as default
b. -- github-host: if is not supplied, Qubeship will default the SCM to https://github.com. it should only be of the pattern https://hostname.
                    DO NOT specify context path. Qubeship will automatically remove the trailing slashes if specified
c.  --install-registry : if you want to register  a default registry on installation , set to true.
                       Community Users:
                            Qubeship will expect  the registry details to be provided by user in  qubeship_home/endpoints/registry.config
                            Please refer to qubeship_home/endpoints/registry.config.template for example.
                       BETA Users: this is done automatically.
c.  --install-target : if you want to register  a default target endpoint for deployment , set value to one of the supported cluster types
                       supported cluster values are : ["minikube"]
                       Community Users:
                         Qubeship will expect  the kubernetes config details to be provided by user in  qubeship_home/endpoints/kube.config
                         Please refer to qubeship_home/endpoints/kube.config.template for example.
                       BETA Users:
                         this is done automatically.
```

