# Install Qubeship Beta

## Prerequisites
1. Docker Toolbox ()[https://www.docker.com/products/docker-toolbox] which includes the following items

   * Docker Runtime v1.11 and above
   * Docker-compose
   * Docker-machine
   
   ** Note: Qubeship for now only supports "Docker Toolbox" on macOS. "Docker for Mac" and Linux will be supported soon.

2. Text Editor
3. Curl [download from official site](https://curl.haxx.se/download.html#MacOSX)
4. jq [download from github](https://stedolan.github.io/jq/download/)
5. **_A valid and running Docker Host._**
   
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



