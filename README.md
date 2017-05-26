# Install Qubeship Beta

## Prerequisites
1. Docker Toolbox ()[https://www.docker.com/products/docker-toolbox] which includes the following items

   * Docker Runtime v1.11 and above
   * Docker-compose
   * Docker-machine
   
   ** Note: Qubeship for now only supports "Docker Toolbox" on macOS. "Docker for Mac" and Linux will be supported soon.

2. Text Editor
3. Curl [download from official site](https://curl.haxx.se/download.html#MacOSX)
4. **_A valid and running Docker Host._**
   
   You should be able to run the following command and get a valid output:
```
    docker ps -a 
    CONTAINER ID        IMAGE                                                             COMMAND                  CREATED             STATUS                  PORTS                                                                      NAMES
```
----
## Install

1. Clone the repo
```
git clone https://github.com/Qubeship/bootstrap && cd bootstrap && git checkout community_beta 
```

2. **Configuration** 
   * **Beta Users**: copy the **beta.config** file to qubeship_home/config  (** this file will be a part of beta welcome kit email that you received from qubeship **)
   
   * **Community users**: create  scm.config file in qubeship_home/config. For instructions, please refer to: https://github.com/Qubeship/bootstrap/blob/master/OPEN_SOURCE_README.md

3.  Run the install script
```
  ./install.sh --username <githubusername> --password [gitpassword]  [--organization github_organization] [--github-host github_enterprise_url]
```

At the end of installation, you should see a message like this
```
Your Qubeship Installation is ready for use!!!!
Here are some useful urls!!!!
API: http://192.168.99.100:9080
You can use your GITHUB credentials to login !!!!
APP: http://192.168.99.100:7000
```

4. login to the qubeship app url, showed at the end of step 3.


### Uninstall:
1. If your release has errors, simply run the following from the qubeship release directory
	./uninstall.sh —remove-minikube
2. Restart the installation process

### Features:
1. Github.com / Github Enterprise
2. Registry support : Private Docker Registry , DockerHub, Quay.io
3. Deployment: Kubernetes , Minikube
4. Default out of the box toolchains for python , java, gradle and go
5. Default out of the box opiniion for end to end build, test and deploy
6. Sonar Qube

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
Copy and paste the client id and secret into the qubeship_home/config/scm.config 
in the variables **GITHUB_BUILDER_CLIENTID** and **GITHUB_BUILDER_SECRET**

#### 2. CLI: 
```
    Client Name : qubeship-cli
    Home Page : https://qubeship.io
    Description : Qubeship CLI client
    call back URL: http://cli.qubeship.io/index.html
```
Copy and paste the client id and secret into the qubeship_home/config/scm.config 
in the variables **GITHUB_CLI_CLIENTID** and **GITHUB_CLI_SECRET**

#### 3. GUI:  
```
    Client Name : qubeship-gui
    Home Page : https://qubeship.io
    Description : Qubeship GUI client
    call back URL:  http://<docker endpoint>:7000/api/v1/auth/callback?provider=github
```

Copy and paste the client id and secret into the qubeship_home/config/scm.config 
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



### FAQ:
   1. How do I install against Github Enterprise
   2. How to install Qubeship with kubernetes
   3. How to install Qubeship with a default docker registry
   4. How to view services deployed via qubeship to minikube 

### Help

1. ./install.sh --help
```
/install.sh --help
Usage: install.sh [-h|--help] [--verbose] [--username githubusername] [--password githubpassword]  [--organization orgname] [--github-host host ] [--install-registry] [--install-target target_cluster_type]  [--install-sample-projects]
    --username                  github username
    --password                  github password. password can be provided in command line. if not, qubeship will prompt for password
    --organization              default github organization
    --github-host               github host [ format: http(s)://hostname ]
    --install-target            install a target endpoint of target_cluster_type [minikube, swarm] (**default true for beta users)
    --install-registry          install a private docker registry endpoint (**default true for beta users))
    --install-sample-projects   install sample qubeship projects
    --verbose                   verbose mode.
    --auto-pull                 automatic pull of docker images from qubeship

a. -- organization :            if it is not specified, Qubeship will take the users personal organization as default
b. -- github-host:              if is not supplied, Qubeship will default the SCM to https://github.com. it should only be of the pattern https://hostname.
                                DO NOT specify context path. Qubeship will automatically remove the trailing slashes if specified
c.  --install-registry :        if you want to register  a default registry on installation , set to true.
                                Community Users:
                                    Qubeship will expect  the registry details to be provided by user in  qubeship_home/endpoints/registry.config
                                    Please refer to qubeship_home/endpoints/registry.config.template for example.
                                BETA Users:
                                    this is done automatically. no action required
d.  --install-target :          if you want to register  a default target endpoint for deployment , set value to one of the supported cluster types
                                supported cluster values are : ["minikube"]
                                Community Users:
                                    Qubeship will expect  the kubernetes config details to be provided by user in qubeship_home/endpoints/kube.config
                                    Please refer to qubeship_home/endpoints/kube.config.template for example.
                                BETA Users:
                                    this is done automatically.
e.  --install-sample-projects   install sample qubeship projects

```

### Post Install - viewing services deployed to qubeship
In order to view the services deployed via qubeship, you will have to take some special steps. This is necessary because the local kubernetes installation doesn't give access to services over standard endpoints. As a one time setup effort, you have to run this from the bootsrap directory.
```
  qubeship_home/bin/kube-service-patch.sh
```
Step 1: determine your service name:
    this is the container prefix of your project.
    `kubectl get services`
```
NAME                             CLUSTER-IP   EXTERNAL-IP   PORT(S)          AGE
kubernetes                       10.0.0.1     <none>        443/TCP          3d
qubefirstpythonproject-service   10.0.0.63    <none>        443/TCP,80/TCP   2h
```

Step 2:
use the access_qubeservice utilty to figure out your service url  
```
qubeship_home/bin/access_qubeservice.sh qubefirstpythonproject-service /api
qubefirstjavaproject-service
IP address of the qubefirstjavaproject-service-service : 10.0.0.63 for api
curl http://10.0.0.63/api
{"api": "hello world"}
```   



