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
  ./qubeship_beta_install.sh
```

4. login to the qubeship app
