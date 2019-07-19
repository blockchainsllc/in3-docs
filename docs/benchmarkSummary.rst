**********
Benchmarks
**********

These benchmarktests aim to test the in3 version for stability and performance on the server. As a result we can give estimate thewe resources needed in order to serve many clients.


Setup and Tools
###############

- Jmeter is used to send request parallelly to the server
- Custom python scripts to generate list of transactions to use as well as randomize them - used to create test plan
- Link for making Jmeter tests online without setting up the server: https://www.blazemeter.com/

JMeter can be downloaded from: https://jmeter.apache.org/download_jmeter.cgi

 Install JMeter on Mac OS With HomeBrew

    1. Open a Mac Terminal, where we will be running all the commands.

    2. First, check to see if HomeBrew is installed on your Mac by executing this command. You can either run brew help or brew -v

    3. If HomeBrew is not installed, run the following command to install HomeBrew on Mac

       .. code-block:: sh

          ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
          Once HomeBrew is installed, we can continue to install JMeter.

    4. To install JMeter without the extra plugins, run the following command

      .. code-block:: sh

        brew install jmeter
    
    5. To install JMeter with all the extra plugins, run the following command

       .. code-block:: sh

        brew install jmeter --with-plugins
    
    6. Finally, verify the installation by executing jmeter -v
    
    7. Run JMeter using 'jmeter' which should load the JMeter GUI.
    
 JMeter on EC2 instance CLI only (testing pending):

    1. Login to AWS and navigate to the EC2 instance page
    
    2. Create a new instance, choose an Ubuntu AMI]
    
    3. Provision the AWS instance with the needed information, enable CloudWatch monitoring
    
    4. Configure the instance to allow all outgoing traffic, and fine tune Security group rules to suit your need
    
    5. Save the SSH key, use the SSH key to login to the EC2 instance
    
    6. Install Java:

       .. code-block:: sh

          sudo add-apt-repository ppa:linuxuprising/java
          sudo apt-get update
          sudo apt-get install oracle-java11-installer
    
    7. Install JMeter using:

       .. code-block:: sh

          sudo apt-get install jmeter
       
    8. Get the JMeter Plugins:

       .. code-block:: sh

            wget http://jmeter-plugins.org/downloads/file/JMeterPlugins-Standard-1.2.0.zip
            wget http://jmeter-plugins.org/downloads/file/JMeterPlugins-Extras-1.2.0.zip
            wget http://jmeter-plugins.org/downloads/file/JMeterPlugins-ExtrasLibs-1.2.0.zip
       
    9. Move the unzipped jar files to the install location:

       .. code-block:: sh

         sudo unzip JMeterPlugins-Standard-1.2.0.zip -d /usr/share/jmeter/
         sudo unzip JMeterPlugins-Extras-1.2.0.zip -d /usr/share/jmeter/
         sudo unzip JMeterPlugins-ExtrasLibs-1.2.0.zip -d /usr/share/jmeter/
       
    10. Copy the jml file to the EC2 instance using:
       (On host computer)

       .. code-block:: sh

          scp -i <path_to_key> <path_to_local_file> <user>@<server_url>:<path_on_server>
       
    11. Run JMeter without the GUI:

       .. code-block:: sh

          jmeter -n -t <path_to_jmx> -l <path_to_output_jtl>
       
    12. Copy the JTL file back to the host computer and view the file using JMeter with GUI
    

Python script to create test plan:

    1. Navigate to the txGenerator folder in the in3-tests repo
    2. Run the main.py file with mentioning the start block (-s), end block (-e) and number of blocks to choose in this range (-n). The script will randomly choose 3 transactions per block. 
    3. The transactions chosen are sent through a tumble function, resulting in a randomized list of transactions from random blocks. This should be a relistic scenario to test with, and prevents too many concurrent cache hits. 
    4. Import the generated CSV file into the loaded test plan on JMeter
    5. Refer to existing test plans for information on how to read transactions from CSV files and to see how it can be integrated into the requests
    

Considerations
##############

 - When the in3 benchmark is run on a new server, create a baseline before applying any changes
 - Run the same benchmark test with the new codebase, test for performance gains
 - The tests can be modified to include number of users and duration of the test. For a stress test, choose 200 users and a test duration of 500 seconds or more. 
 - When running in an EC2 instance, up to 500 users can be simulated without issues. Running in GUI mode reduces this number. 
 - A beneficial method for running the test is to slowly ramp up the user count, start with a test of 10 users for 120 seconds in order to test basic stability. Work your way up to 200 users and longer durations. 
 - Parity might often be the bottleneck, you can confirm this by using the get_avg_stddev_in3_response.sh script in the scripts directory of the in3-test repo. This would help show what optimizations are needed

Results/Baseline
################

 - The baseline test was done with our existing server running multiple docker containers, it is not indicative of a perfect server setup. But it can be used to benchmark upgrades to our codebase. 
 - The baseline for our current system is given below, this system has multithreading enabled and has been tested with ethCalls included in the test plan. 
 
+-------------+--------------------------------------+----------------+--------------------+-----+---------------------+-----------------------+-------------------------+----------------------------+-------------+---------------------+----------------------------------------------------------------------------------------------------------------------+
| Test number | Test description                     | Users/duration | Number of requests | tps | getBlockByHash (ms) | getBlockByNumber (ms) | getTransactionHash (ms) | getTransactionReceipt (ms) | EthCall(ms) | eth_getStorage (ms) | Notes                                                                                                                |
+=============+======================================+================+====================+=====+=====================+=======================+=========================+============================+=============+=====================+======================================================================================================================+
| T1          | Testing Multithreading with ethCalls |                |                    |     |                     |                       |                         |                            |             |                     |                                                                                                                      |
+-------------+--------------------------------------+----------------+--------------------+-----+---------------------+-----------------------+-------------------------+----------------------------+-------------+---------------------+----------------------------------------------------------------------------------------------------------------------+
|             |                                      | 10/120s        |                    |     |                     |                       |                         |                            |             |                     |                                                                                                                      |
+-------------+--------------------------------------+----------------+--------------------+-----+---------------------+-----------------------+-------------------------+----------------------------+-------------+---------------------+----------------------------------------------------------------------------------------------------------------------+
|             |                                      | 20/120s        | 4800               | 40  | 580                 | 419                   | 521                     | 923                        | 449         | 206                 |                                                                                                                      |
+-------------+--------------------------------------+----------------+--------------------+-----+---------------------+-----------------------+-------------------------+----------------------------+-------------+---------------------+----------------------------------------------------------------------------------------------------------------------+
|             |                                      | 40/120s        | 5705               | 47  | 1020                | 708                   | 902                     | 1508                       | 816         | 442                 |                                                                                                                      |
+-------------+--------------------------------------+----------------+--------------------+-----+---------------------+-----------------------+-------------------------+----------------------------+-------------+---------------------+----------------------------------------------------------------------------------------------------------------------+
|             |                                      | 80/120s        | 7970               | 66  | 1105                | 790                   | 2451                    | 3197                       | 984         | 452                 |                                                                                                                      |
+-------------+--------------------------------------+----------------+--------------------+-----+---------------------+-----------------------+-------------------------+----------------------------+-------------+---------------------+----------------------------------------------------------------------------------------------------------------------+
|             |                                      | 100/120s       | 6911               | 57  | 1505                | 1379                  | 2501                    | 4310                       | 1486        | 866                 |                                                                                                                      |
+-------------+--------------------------------------+----------------+--------------------+-----+---------------------+-----------------------+-------------------------+----------------------------+-------------+---------------------+----------------------------------------------------------------------------------------------------------------------+
|             |                                      | 110/120s       | 6000               | 50  | 1789                | 1646                  | 4204                    | 5662                       | 1811        | 1007                |                                                                                                                      |
+-------------+--------------------------------------+----------------+--------------------+-----+---------------------+-----------------------+-------------------------+----------------------------+-------------+---------------------+----------------------------------------------------------------------------------------------------------------------+
|             |                                      | 120/500s       | 32000              | 65  | 1331                | 1184                  | 4600                    | 5314                       | 1815        | 1607                |                                                                                                                      |
+-------------+--------------------------------------+----------------+--------------------+-----+---------------------+-----------------------+-------------------------+----------------------------+-------------+---------------------+----------------------------------------------------------------------------------------------------------------------+
|             |                                      | 140/500s       | 31000              | 62  | 1666                | 1425                  | 5207                    | 6722                       | 1760        | 941                 |                                                                                                                      |
+-------------+--------------------------------------+----------------+--------------------+-----+---------------------+-----------------------+-------------------------+----------------------------+-------------+---------------------+----------------------------------------------------------------------------------------------------------------------+
|             |                                      | 160/500s       | 33000              | 65  | 1949                | 1615                  | 6269                    | 7604                       | 1900        | 930                 | In3 -> 400ms, rpc -> 2081ms                                                                                          |
+-------------+--------------------------------------+----------------+--------------------+-----+---------------------+-----------------------+-------------------------+----------------------------+-------------+---------------------+----------------------------------------------------------------------------------------------------------------------+
|             |                                      | 200/500s       | 34000              | 70  | 1270                | 1031                  | 12500                   | 14349                      | 1251        | 716                 | At higher loads, the rpc delay adds up. It is the bottlenecking factor. Able to handle 200 users on sustained loads. |
+-------------+--------------------------------------+----------------+--------------------+-----+---------------------+-----------------------+-------------------------+----------------------------+-------------+---------------------+----------------------------------------------------------------------------------------------------------------------+
 
 - More benchmarks and their results can be found in the in3-tests repo
 
 
