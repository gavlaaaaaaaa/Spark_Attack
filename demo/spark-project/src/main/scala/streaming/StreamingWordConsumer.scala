package scala.streaming

import org.apache.spark.streaming.{Seconds, StreamingContext}
import org.apache.spark.SparkContext._
import org.apache.spark.SparkConf
import org.apache.spark.HashPartitioner

import org.apache.spark.streaming.dstream.TransformedDStream

import org.apache.log4j.Logger
import org.apache.log4j.Level
import org.apache.spark.storage.StorageLevel

import java.net._
import java.io._
import scala.io._


import scala.io.Source




object StreamingWordConsumer {

		val sparkConf = new SparkConf().setAppName("Stream Words")
		val ssc = new StreamingContext(sparkConf, Seconds(10))




  def main(args: Array[String]) {
    if (args.length < 1) {
      System.err.println("Usage: StreamingWordConsumer <hostname> <port>")
      System.exit(1)
    }

   


	val checkpointDir = args(0)
    val hostname = args(1)
	val port = args(2).toInt
    val returnIP = args(3)
	val returnPort = args(4).toInt
		val wordsToPrint = 60


ssc.checkpoint(checkpointDir)

    val lines = ssc.socketTextStream(hostname, port)


		val source : InputStream = getClass.getResourceAsStream("/StopWords.txt")
		val stopWords = scala.io.Source.fromInputStream(source).mkString.split("\n")
		
		val sourcePos : InputStream = getClass.getResourceAsStream("/PositiveWords.txt")
		val positiveWords = scala.io.Source.fromInputStream(sourcePos).mkString.split("\n")

		val sourceNeg : InputStream = getClass.getResourceAsStream("/NegativeWords.txt")
		val negativeWords = scala.io.Source.fromInputStream(sourceNeg).mkString.split("\n")		



    lines.persist(StorageLevel.MEMORY_ONLY)

    //Alpha characters only
    val alphaOnly = lines.flatMap(line =>line.split("\\s"))

    //Remove stop words
    val removedStopWords  = alphaOnly.filter(!stopWords.contains(_))

    //Count words
    val wordDstream = removedStopWords.map(x => (x, 1))

    val initialRDD = ssc.sparkContext.parallelize(Array[(String,Int)]()) 

    val stateDstream = wordDstream.updateStateByKey[Int](newUpdateFunc, new HashPartitioner (ssc.sparkContext.defaultParallelism), true, initialRDD)
    val sortedreqs = stateDstream.transform(rdd => rdd.sortByKey(false))

    sortedreqs.foreachRDD(rdd=>{
        try{
            val s = new Socket(InetAddress.getByName(returnIP), returnPort)
            val out = new PrintStream(s.getOutputStream())

            var count = 1

            val rdd_arr = rdd.takeOrdered(wordsToPrint)(Ordering[Int].reverse.on(_._2)).map(classify(_,positiveWords,negativeWords)) //.collect()

            var jsonOut = "{\"name\": \"flare\",\"children\":["

            rdd_arr.foreach(item =>{
                jsonOut = jsonOut +  "{\"name\":\"" + item._1 +"\",\"size\": " + item._2 + ",\"type\":\"" + item._3 + "\"}"
                jsonOut = jsonOut + ","
            })

            jsonOut = jsonOut.replaceAll(",$","")
            jsonOut = jsonOut + "]}\n"

            out.println(jsonOut)
            out.flush()
            s.close()
        } catch {
            case e: java.net.ConnectException => println("exit"); try { ssc.stop(); } catch { case e:java.lang.InterruptedException=>System.exit(1);}
        }
    })

    ssc.start()
    ssc.awaitTermination //OrTimeout(100000000)
    ssc.stop()
    println("DONE")

 }
}
