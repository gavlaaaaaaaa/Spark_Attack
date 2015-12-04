#!/bin/sh
echo Started > /home/training/sparkjob.txt
echo ${1} >> /home/training/sparkjob.txt
ssh -n -f training@127.0.0.1 "spark-submit --master local[4] --class scala.streaming.TopWords /home/training/Documents/Tech_Challenge/Spark_Attack/spark-project/target/scala-2.10/spark-examples-1.5.1-hadoop2.2.0.jar <!!!4 keys space delim here!!!> 127.0.0.1 ${1} > /home/training/out.txt 2>&1 &"
