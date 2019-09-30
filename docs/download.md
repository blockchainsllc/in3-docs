# Downloading in3

in3 is divided into two distinct components, the in3-node and in3-client. The in3-node is currently written in typescript, whereas the in3-client has a version in typescript as well as a smaller and more feature packed version written in C. 

In order to compile from scratch, please use the sources from our [github page](https://github.com/slockit/in3) or the [public gitlab page](https://public-git.slock.it). Instructions for building from scratch can be found in our documentation.

The in3-server and in3-client has been published in multiple package managers and locations, they can be found here:

```eval_rst
+----------------+--------------------+---------------------------------------------------------------------+------------------------------------------------------------------------------------------------------+
|                | Package manager    |                         Link                                        |                                               Use case                                               |                                                                                                             
+================+====================+=====================================================================+======================================================================================================+
| in3-node(ts)   |    Docker Hub      | `DockerHub <https://hub.docker.com/r/slockit/in3-node>`_            |     To run the in3-server, which the in3-client can use to connect to the in3 network                |                                                                                                                     
+----------------+--------------------+---------------------------------------------------------------------+------------------------------------------------------------------------------------------------------+
| in3-client(ts) |        NPM         | `NPM(https://www.npmjs.com/package/in3)                             |                                    To use with js applications                                       |                                                                                                                     
+----------------+--------------------+---------------------------------------------------------------------+------------------------------------------------------------------------------------------------------+
| in3-client(C)  |  Ubuntu Launchpad  | `Ubuntu(https://launchpad.net/~devops-slock-it/+archive/ubuntu/in3) |     It can be quickly integrated on linux systems, IoT devices or any micro controllers              |                                                                                                                     
+----------------+--------------------+---------------------------------------------------------------------+------------------------------------------------------------------------------------------------------+
|                |    Docker Hub      | [DockerHub](https://hub.docker.com/r/slockit/in3)                   |                       Quick and easy way to get in3 client running                                   |                                                                                                                     
+----------------+--------------------+---------------------------------------------------------------------+------------------------------------------------------------------------------------------------------+
|                |      Brew          | [Homebrew]( https://github.com/slockit/homebrew-in3)                |                    Easy to install on MacOS or linux/windows subsystems                              |                                                                                                                     
+----------------+--------------------+---------------------------------------------------------------------+------------------------------------------------------------------------------------------------------+
|                |    Release page    | [Github](https://github.com/slockit/in3-c/releases)                 |                       For directly playing with the binaries/deb/jar/wasm files                      |                                                                                                                     
+----------------+--------------------+---------------------------------------------------------------------+------------------------------------------------------------------------------------------------------+
```


## in3-node
### Docker Hub
1. Pull the image from docker using ```docker pull slockit/in3-node```
2. In order to run your own in3-node, you must first register the node. The information for registering a node can be found 
[here](https://in3.readthedocs.io/en/develop/getting_started.html#registering-an-incubed-node)
3. Run the in3-node image using a direct docker command or a docker-compose file, the parameters for which are explained 
[here](https://in3.readthedocs.io/en/develop/api-node.html)


## in3-client (ts)
### npm
1. Install the package by running ```npm install --save in3```
2. ```import In3Client from "in3"```
3. View our examples for information on how to use the module

## in3-client(C)
### Ubuntu Launchpad 
 There are 2 packages published to Ubuntu Launchpad: ```in3``` and ```in3-dev```. The package ```in3``` only installs the
 binary file and allows you to use in3 via command line. The package ```in3-dev``` would install the binary as well as 
 the library files, allowing you to use in3 not only via command line, but also inside your C programs by including the
 statically linked files. 
 
 #### Installation instructions for ```in3```:
 
 This package will only install the in3 binary in your system.
 
 1. Add the slock.it ppa to your system with
 ```sudo add-apt-repository ppa:devops-slock-it/in3```
 2. Update the local sources ```sudo apt-get update```
 3. Install in3 with ```sudo apt-get install in3```

 #### Installation instructions for ```in3-dev```:
 
 This package will install the statically linked library files and the include files in your system. 
 
 1. Add the slock.it ppa to your system with
 ```sudo add-apt-repository ppa:devops-slock-it/in3```
 2. Update the local sources ```sudo apt-get update```
 3. Install in3 with ```sudo apt-get install in3-dev```
 
 ### Docker Hub
 #### Usage instructions:
 1. Pull the image from docker using ```docker pull slockit/in3```
 2. Run the client using: ```docker run -d -p 8545:8545  slockit/in3:latest --chainId=goerli -port 8545```
 3. More parameters and their descriptions can be found [here](https://in3.readthedocs.io/en/develop/getting_started.html#as-docker-container). 
 
 ### Release page
 #### Usage instructions:
 1. Navigate to the in3-client [release page](https://github.com/slockit/in3-c/releases) on this github repo 
 2. Download the binary that matches your target system, or read below for architecture specific information:
 
 ###### For WASM:
 1. Download the WASM binding with ```npm install --save in3-wasm```
 2. More information on how to use the WASM binding can be found [here](https://www.npmjs.com/package/in3-wasm)
 3. Examples on how to use the WASM binding can be found [here](https://github.com/slockit/in3-c/tree/master/examples/js)
 
 ###### For C library:
 1. Download the C library from the release page or by installing the ```in3-dev``` package from ubuntu launchpad
 2. Include the C library in your code, as shown in our [examples](https://github.com/slockit/in3-c/tree/master/examples/c)
 3. Build your code with ```gcc -std=c99 -o test test.c -lin3 -lcurl```, more information can be found [here](https://github.com/slockit/in3-c/blob/master/examples/c/build.sh)
 
  ###### For Java:
  1. Download the Java file from the release page
  2. Use the java binding as show in our [example](https://github.com/slockit/in3-c/blob/master/examples/java/GetBlockRPC.java)
  3. Build your java project with ```javac -cp $IN3_JAR_LOCATION/in3.jar *.java```
  
 ### Brew
 #### Usage instructions:
 1. Ensure that homebrew is installed on your system
 2. Add a brew tap with ```brew tap slockit/in3```
 3. Install in3 with ```brew install in3```
 4. You should now be able to use ```in3``` in the terminal, can be verified with ```in3 eth_blockNumber```
 
