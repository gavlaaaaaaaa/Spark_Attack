All integrated now - drop down to switch between twitter and voce. Just need to change the run_spark.sh script to replace <...> with the variables - change the paths, ips, ports. Need to change in SparkListener the path to the run_spark.sh script. run_spark.sh needs to go on tomcat to ssh command to master. Switching on the ui between twitter / voice and clicking go should call the run_spark.sh script.

Not working on cluster yet though :(
