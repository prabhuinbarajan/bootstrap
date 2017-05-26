# Install Qubeship Beta

## Prerequisites
1. Docker Toolbox ()[https://www.docker.com/products/docker-toolbox] which includes the following items

   * Docker Runtime v1.11 and above
   * Docker-compose
   * Docker-machine
   
   ** **_Note_** **: Qubeship for now only supports "Docker Toolbox" on macOS. "Docker for Mac" and Linux will be supported soon.

2. Text Editor
3. Curl [download from official site](https://curl.haxx.se/download.html#MacOSX)
4. **_A valid and running Docker Host._**
   
   You should be able to run the following command and get a valid output:
```
    docker ps -a 
    CONTAINER ID        IMAGE                                                             COMMAND                  CREATED             STATUS                  PORTS                                                                      NAMES
```
----
5. Make sure that you can connect to the internet from within your corporate firewalls. Qubeship uses firebase and firebase    requires internet connectivity.

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
2. Registry support : Private Docker Registry, DockerHub, Quay.io
3. Deployment: Kubernetes, Minikube
4. Default out of the box toolchains for python, java, gradle and go
5. Default out of the box opinion for end to end build, test and deploy
6. Sonar Qube


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



### FAQ:
   1. How do I stop Qubeship services?
   
      In the bootstrap folder, do a: `./down.sh`
      
   1. If the Qubeship services stop, how can I start them again?
      
      In the bootstrap folder, do a: `./run.sh`. Note: After the script has finished, it will take the Qubeship services a few minutes to further process before they become available.
      
      When Qubeship is ready, you'll be able to use the Swagger API at [http://192.168.99.100:9080](http://192.168.99.100:9080) and be able to access Qubeship itself at [http://192.168.99.100:7000](http://192.168.99.100:7000). Note: If this Qubeship URL does not show you any content, try logging out and in again.
      

   1. I rebooted my machine and Qubeship stopped working, what should I do?
      
      The best way to avoid this problem is to "Save State" in VirtualBox before rebooting and then "start" the VM again.

      If you didn't do this, here are some more options:
      
      * Open VirtualBox and make sure the "default" VM is running. If not, "start" it.
      * Make sure the VM has finished booting and is showing you a terminal UI.
      * In the bootstrap folder, do a: `./run.sh` to restart Qubeship's services.
   
   1. I tried installing Qubeship, but the script is giving me an error: exec: “Docker-credential-osxkeychain”: executable file not found in $PATH out: ``.         What’s wrong?

    It sounds like your config file is slightly misconfigured. This can happen if you’ve converted from Docker for Mac to Docker Toolbox, or  similar nonstandard situations. Your system thinks that your credentials are being stored on an external location (which is good, as it’s typically much more secure than storing it locally), but it lacks the actual keychain executable to make the connection. You can confirm this by looking in your ./docker/config.json file for
    “credsStore”: “osxkeychain”
    If you see it, then you’ve got confirmation. To fix this, you have two options:

    a. Install the keychain: Open ./docker/config.json and see if your file has
           “credsStore”: “osxkeychain”
    If it does, then you need to go to https://github.com/docker/docker-credential-helpers/releases, find the Release version marked ‘Latest release’ (probably the top block), and then click ‘docker-credential-osxkeychain-v#.#.#-#####.tar.gz’ where ‘#.#.#’ is the release number. Unzip the downloaded file, and then put the resulting ‘docker-credential-osxkeychain’ executable file into your /usr/local/bin directory. Now try installing Qubeship again.

    --- or ---

    b. Tell your system you want to store your credentials locally: Simply remove the “credsStore”: “osxkeychain” from ./docker/config.json and then try installing Qubeship again. Easy, but less secure.

    Again, we highly recommend that you try for option ‘a’ as it’s definitely the most secure way to go.


        
   1. How do I install using Github Enterprise?
   1. How to install Qubeship with Kubernetes?
   1. How to install Qubeship with a default Docker registry?
   1. How can I view services deployed by Qubeship to Minikube? 

