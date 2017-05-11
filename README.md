# bootstrap
1. clone the repo
```
git clone https://github.com/Qubeship/bootstrap
git checkout community_beta 
```
2. edit the qubeship_home/config/qubeship.config file.
The settings can be found from your GITHUB account, "settings" section and under "OAuth applications"

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

# Prerequisites
1. Docker Runtime v1.11 and above
2. Docker-compose
3. [Docker-machine](https://github.com/docker/machine/releases)
3. Text Editor
4. Curl 
5. A valid docker host
`


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

