# Install Qubeship Opensource

## Prerequisites

1. Docker Runtime v1.11 and above
2. Docker-compose
3. [Docker-machine](https://github.com/docker/machine/releases)
4. Text Editor
5. Curl 
6. Docker Host should be up and running.
Use the following command to see if Docker Host is running:
```
docker ps -a 
 +    CONTAINER ID        IMAGE                                                             COMMAND                  CREATED             STATUS                  

PORTS                                                                      NAMES
```
----
## Install

1. Clone the repo
```
git clone https://github.com/Qubeship/bootstrap
cd bootstrap ; git checkout community_beta 
```

2. prepare the scm.config file in qubeship_home/config/scm.config. refer to configure qubeship section for instructions

3.  Run the install script
```
  ./install.sh <githubusername> [gitpassword | -p]  [githuburl] [githubsystemorg]
```

4. Use Qubeship. You can find more documentation online at qubeship.io/docs. 


If you have any questions, please reach out to us at support@qubeship.io

----


## Configure Qubeship

### How to Determine Your Docker Endpoint
Your Docker Host is where Qubeship resides. Use this endpoint to configure Qubeship OAuth applications in GitHub. 

    * Is your Docker Host running locally? 
        Your Docker Endpoint is 'localhost'

    * Is Docker Running on a virtual machine or docker machine?
       Use the following command:
       ```
       $  docker-machine ip
       ```
    
    The result should be an ip address that you can use as your Docker Endpoint. 
    
    * Is your Docker host on a remote machine? This "machine" is usually a Docker Swarm cluster. 
       ```
       $ echo $DOCKER_HOST | awk '{ sub(/tcp:\/\//, ""); sub(/:.*/, ""); print $0}'
        ```

### Github Configuration 
There are three primary interfaces to Qubeship. 
  * Qubeship GUI application - Qubeship user interface access
  * Qubeship CLI application - Qubeship command line access
  * Qubeship Builder - orchestrates the Qubeship workflow

With open source Qubeship, you only have access to the Builder only. 

Qubeship manages authentication for all three interfaces through Github OAuth. This allows for single sign-on 
through Github identity management. The first time you use Qubeship, register the Builder 
as an 0Auth application in GitHub. You only need to do this once. 
 
To configure OAuth applications, enter the following information in GitHub OAuth:

#### 1. Builder:  
```
    Client Name : qubeship-builder
    Home Page : https://qubeship.io
    Description : Qubeship Builder
    call back URL: http://<docker endpoint>:8080/securityRealm/finishLogin
```
Copy and paste the client id and secret into the qubeship_home/config/qubeship.config 
in the variables **GITHUB_BUILDER_CLIENTID** and **GITHUB_BUILDER_SECRET**

#### 2. CLI: 
```
    Client Name : qubeship-cli
    Home Page : https://qubeship.io
    Description : Qubeship CLI client
    call back URL: http://cli.qubeship.io/index.html
```
Copy and paste the client id and secret into the qubeship_home/config/qubeship.config 
in the variables **GITHUB_CLI_CLIENTID** and **GITHUB_CLI_SECRET**

#### 3. GUI:  
```
    Client Name : qubeship-gui
    Home Page : https://qubeship.io
    Description : Qubeship GUI client
    call back URL:  http://<docker endpoint>:7000/api/v1/auth/callback?provider=github
```

Copy and paste the client id and secret into the qubeship_home/config/qubeship.config 
in the variables **GITHUB_GUI_CLIENTID** and **GITHUB_GUI_SECRET**

### Other Configuration Entries

#### 4. GITHUB_ENTERPRISE_HOST:
This is the url for the Github SCM instance to be used with qubeship. Qubeship will use this system as the defacto identity manager for Qubeship authentication , as well as use this for pulling the source code for builds. if this is left blank, the GITHUB_ENTERPRISE_HOST will be defaulted to https://github.com
Qubeship currently supports only http(s):// . SSH is in pipeline. 

```
GITHUB_ENTERPRISE_HOST  =   # no trailing slashes , only schema://hostname
```
#### 5. SYSTEM_GITHUB_ORG:  
This denotes the default system  organization for Qubeship. All users with membership to this org will be considered admin users for that Qubeship instance.   
![Example](https://raw.githubusercontent.com/Qubeship/bootstrap/master/GithubORG.png)  
if this is left blank, the installers personal github org will be used as default.  

```
SYSTEM_GITHUB_ORG  =  # if left blank , default will be install  users personal github org
```

### Config File Example

This is what the config file looks like:
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
```

### Github Security
- we need the github username and password credentials to perform the qubeship initialization steps. this is only collected in the install process to generate intermediate oauth tokens using https://developer.github.com/v3/oauth_authorizations/ and is used for non-interactive qubeship logins during the setup process. The user name / password credentials so collected are discarded at the end of the installation process.  
After initial setup , Qubeship uses OAUTH authentication as described in https://developer.github.com/v3/oauth/.  
