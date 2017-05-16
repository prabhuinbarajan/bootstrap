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

2. Edit the qubeship_home/config/qubeship.config file.
You can find the NGROK_HOSTNAME, NGROK_AUTH, BETA_ACCESS_USERNAME, and BETA_ACCESS_TOKEN in your Welcome Kit email. You can obtain the
client ID and secret information from your GitHub account in the "Settings" section under "0Auth applications." Specific doc
on how to obtain this information below under "Configure Qubeship."

3.  Run the configuration script
```
  ./init_qubeship.sh
```

4. Start Qubeship 
```
  ./run.sh
```
5. Run the post configuration script and Login as qubebuilder
```
   ./post_configuration.sh 
```

6. Use Qubeship. You can find more documentation online at qubeship.io/docs. 
If you have any questions, please reach out to us at contactus@qubeship.io


7. Uninstall.  
If you want to reset qubeship on your machine, please use `uninstall` command. It will remove all generted configuration files from the sub-folders of bootstrap. After that, you can re-initialize the bootstrap by starting from step 3 above.


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

Qubeship manages authentication for all three interfaces through Github OAuth. This allows for single sign-on through
Github identity management. The first time you use Qubeship, you must register all three applicaitons as 0Auth applications in GitHub.
You only need to do this once. 

To configure OAuth applications, enter the following information in GitHub OAuth:
#### 1. GUI:  
```
    Client Name : qubeship-gui
    Home Page : https://qubeship.io
    Description : Qubeship GUI client
    call back URL:  http://<docker endpoint>:7000/api/v1/auth/callback?provider=github
```

Copy and paste the client id and secret into the qubeship_home/config/qubeship.config 
in the variables **GITHUB_GUI_CLIENTID** and **GITHUB_GUI_SECRET**

#### 2. CLI: 
```
    Client Name : qubeship-cli
    Home Page : https://qubeship.io
    Description : Qubeship CLI client
    call back URL: http://cli.qubeship.io/index.html
```
Copy and paste the client id and secret into the qubeship_home/config/qubeship.config 
in the variables **GITHUB_CLI_CLIENTID** and **GITHUB_CLI_SECRET**

#### 3. Builder:  
```
    Client Name : qubeship-builder
    Home Page : https://qubeship.io
    Description : Qubeship Builder
    call back URL: http://<docker endpoint>:8080/securityRealm/finishLogin
```
Copy and paste the client id and secret into the qubeship_home/config/qubeship.config 
in the variables **GITHUB_CLI_CLIENTID** and **GITHUB_CLI_SECRET**

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

# optional - use only for beta users. please refer to welcome kit and copy paste these values
NGROK_HOSTNAME=
NGROK_AUTH=
BETA_ACCESS_USERNAME=
BETA_ACCESS_TOKEN=
```



