# bootstrap
1. clone the repo
```
git clone https://github.com/Qubeship/bootstrap
git checkout community_beta 
```
2. edit the qubeship_home/config/qubeship.config file.

   See Qubeship Configuration Guide below for more information. 

3.  run the configuration script
```
  ./init_qubeship.sh
```

4. start qubeship 
```
  ./run.sh
```
5. run the post configuration script and login as qubebuilder
```
   ./post_configuration.sh 
```

6. start using qubeship
```
  
```
----
# Prerequisites
1. Docker Runtime v1.11 and above
2. Docker-compose
3. [Docker-machine](https://github.com/docker/machine/releases)
3. Text Editor
4. Curl 
5. A valid and running docker host.  Docker Host should be up and running. You should be able to run the following command and get a valid output
```
    docker ps -a 
    CONTAINER ID        IMAGE                                                             COMMAND                  CREATED             STATUS                  PORTS                                                                      NAMES
```
----

## Qubeship  Configuration Guide Qubeship  Configuration Guide

### Step 1:  your Docker Endpoint :
*  your docker host is where Qubeship services will be displayed. You will need this in order to configure Qubeship Oauth applications in github. For the purpose , we will refer to this information as DOCKER_ENDPOINT.  There are three variants for running docker , and they all can result in different DOCKER_ENDPOINT , consequently different Qubeship Service endpoints:  
  * Docker running locally - docker for mac or docker on ubuntu runs in this configuration. In this configuration , the docker machine will be running locally
  the DOCKER_ENDPOINT should be `localhost` 
    
  * your docker host is running on a virtual machine also known as docker machine.  
  DOCKER_ENDPOINT could be identified by running the following command  
```
$  docker-machine ip
192.168.99.100
```
  * your docker host is running in a remote machine , usually a docker swarm cluster . you will usually identify your docker machine from DOCKER_HOST variable that you set. it will be something like `tcp://10.130.228.202:2376` 
   DOCKER_ENDPOINT could be identifed through the following command:  
```
$ echo $DOCKER_HOST | awk '{ sub(/tcp:\/\//, ""); sub(/:.*/, ""); print $0}'
10.130.228.202
```

### Step 2 : Qubeship  Configuration Entries - qubeship.config file
A qubeship configuration file looks like this. we will go over each configuration entry in this section
```
#optional - use only for onprem github : format : https://github_enterprise_host (no trailing slash)
GITHUB_ENTERPRISE_HOST=

# required
SYSTEM_GITHUB_ORG=
# Qubeship GUI client Authentication Realm
GITHUB_GUI_CLIENTID=
GITHUB_GUI_SECRET=
# Qubeship CLI client Authentication Realm
GITHUB_BUILDER_CLIENTID=
GITHUB_BUILDER_SECRET=
# Qubeship Builder Authentication Realm
GITHUB_CLI_CLIENTID=
GITHUB_CLI_SECRET=

# optional - use only for beta users. please refer to welcome kit and copy paste these values
NGROK_HOSTNAME=
NGROK_AUTH=
BETA_ACCESS_USERNAME=
BETA_ACCESS_TOKEN=
```

No| Configuration | Beta  | Community Edition | Optional | Notes
--|------------ | ----| ----| ----| -------------
1|SYSTEM_GITHUB_ORG | X | X |  | This is the Github Organization you would like to designate as Qubeship System Organization. The users that are members of this organization will have admin privileges in Qubeship.
2|GITHUB_GUI_CLIENTID | X | |   | This is the OAuth Application client ID and secret for the qubeship GUI. See Github Configuration - Builder
3|GITHUB_GUI_SECRET | X |  |    | See Github Configuration - GUI
4|GITHUB_BUILDER_CLIENTID | X | X | | This is the OAuth Application client ID and secret for the qubeship builder. See Github Configuration - Builder
5|GITHUB_BUILDER_SECRET | X | X |  |See Github Configuration - Builder
6|GITHUB_CLI_CLIENTID | X | X |  |This is the OAuth Application client ID and secret for the qubeship CLI. See Github Configuration - CLI
7|GITHUB_CLI_SECRET | X |  X|   |See Github Configuration - CLI
8|NGROK_HOSTNAME |X | |   | this is for generating static webhook listener urls. please refer to beta welcome kit and copy paste these values
9|NGROK_AUTH | X| |   |this is for authenticating static webhook listener urls. please refer to  beta welcome kit and copy paste these values
10|BETA_ACCESS_USERNAME |X | |  | this is the credential for private registry for beta. please refer to  beta welcome kit and copy paste these values
11|BETA_ACCESS_TOKEN |X | |  |this is the credential for private registry for beta. please refer to  beta welcome kit and copy paste these values
11|GITHUB_ENTERPRISE_HOST |X |X |  | your github host (http(s)://host) . The default is github.com. Leave it empty if you want to integrate qubeship with github.com




### Github Configuration 
There are three primary interfaces to Qubeship. 
* Qubeship GUI application - which is the user interface for accessing Qubeship. 
* Qubeship CLI application - for using qubeship on command line
* Qubeship Builder - which will orchestrates the qubeship workflow

Qubeship manages authentication for all three interfaces through Github OAuth. This allows for single signon through Github identity management. This requires registering the above 3 as OAuth applications in github for the very first time you set up qubeship.  


Note to Kate: 
Circle CI : https://circleci.com/docs/enterprise/docker-install/#2-github-app-client-idsecret  
Travis : https://enterprise.travis-ci.com/docs#register-a-github-oauth-app  
CloudBees: https://wiki.jenkins-ci.org/display/JENKINS/Github+OAuth+Plugin#GithubOAuthPlugin-Setup  
Shippable : http://blog.shippable.com/how-to-use-shippable-ci-with-github-enterprise  

You will need the following information as you are configuring registering oauth applications. In your git  

#### 1. GUI:  
```
    Client Name : qubeship-gui
    Home Page : https://qubeship.io
    Description : Qubeship GUI client
    call back URL:  http://<docker endpoint>:7000/api/v1/auth/callback?provider=github
```

the resultant client id and secret should be mapped to variables ***GITHUB_GUI_CLIENTID / GITHUB_GUI_SECRET*** in the qubeship_home/config/qubeship.config file  

#### 2. CLI: 
```
    Client Name : qubeship-cli
    Home Page : https://qubeship.io
    Description : Qubeship CLI client
    call back URL: http://cli.qubeship.io/index.html
```
the resultant client id and secret should be mapped to variables ***GITHUB_CLI_CLIENTID / GITHUB_CLI_SECRET*** in the qubeship_home/config/qubeship.config file  


#### 3. Builder:  
```
    Client Name : qubeship-builder
    Home Page : https://qubeship.io
    Description : Qubeship Builder
    call back URL: http://<docker endpoint>:8080/securityRealm/finishLogin
```
the resultant client id and secret should be mapped to variables ***GITHUB_BUILDER_CLIENTID / GITHUB_BUILDER_SECRET*** in the qubeship_home/config/qubeship.config file  


----

# Deploying specific open source Qubeship services

### 1. Bring down running Qubeship if one is running from previous Bootstrap execution
```
  ./down.sh
 ```
 Docker container pertaining to Qubeship should all have stopped and removed.
 
### 2. Remove docker image of the service you want to replace
```
  docker rmi <imageid>
```

### 3. Configure the .env file

- Make a backup of this file in case you would like to revert back to the community container images.

Update the image repository of the image you want to replace

- Go to the  section under "# images" and to the line that starts with "<service>_IMAGE" where <service> is the name of the service whose image is to be replaced.  Specify the repository where the new image exist.

Eg:
```
  TOOLCHAIN_API_IMAGE=johndoerepo/api_toolchain
```

- Go to the section under "# version" and tot he line stat starts with "<service>_VERSION" where <service> is the name of the service whose image is to be replaced
Eg:
```
  TOOLCHAIN_API_VERSION=latest
```

Save the changes.

### 4. Using the command line, login your docker repository 

### 5. Run bootstrap.sh

If everything is OK, the service from the new image should be executing in the Qubehship enviornment started by Bootstrap

