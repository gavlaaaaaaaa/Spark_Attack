package scala.streaming

import org.apache.spark.streaming.{Seconds, StreamingContext}
import org.apache.spark.SparkContext._
import org.apache.spark.streaming.twitter._
import org.apache.spark.SparkConf
import org.apache.spark.HashPartitioner
import scala.io.Source


import org.apache.log4j.Logger
import org.apache.log4j.Level
import org.apache.spark.storage.StorageLevel


object TopWords {
    def main(args: Array[String]) {
        if (args.length < 4) {
            System.err.println("Usage: TwitterPopularTags <consumer key> <consumer secret> <access token> <access token secret>")
            System.exit(1)
        }


        Logger.getLogger("org").setLevel(Level.OFF)
        Logger.getLogger("akka").setLevel(Level.OFF)


        val updateFunc = (values: Seq[Int], state: Option[Int]) => {
            val currentCount = values.sum
            val previousCount = state.getOrElse(0)

            Some(currentCount + previousCount)
        }
        val newUpdateFunc = (iterator: Iterator[(String, Seq[Int], Option[Int])]) => {
            iterator.flatMap(t => updateFunc(t._2, t._3).map(s => (t._1, s)))
        }


        //val searchTerm = args(4).toLowerCase()
        val Array(consumerKey, consumerSecret, accessToken, accessTokenSecret) = args.take(4)

        val tokens = args.takeRight(args.length - 4)


        System.setProperty("twitter4j.oauth.consumerKey", consumerKey)
        System.setProperty("twitter4j.oauth.consumerSecret", consumerSecret)
        System.setProperty("twitter4j.oauth.accessToken", accessToken)
        System.setProperty("twitter4j.oauth.accessTokenSecret", accessTokenSecret)


        val sparkConf = new SparkConf().setAppName("Top Words")
        val ssc = new StreamingContext(sparkConf, Seconds(30))

        ssc.checkpoint(".")

        val stream = TwitterUtils.createStream(ssc, None, tokens)


        stream.persist(StorageLevel.MEMORY_AND_DISK)


    // Filter on Apprentice
        val App= "/home/training/App.txt"
        val AppList = Source.fromFile(App).getLines.toList
        val AppTerm = AppList.map(line =>line.toLowerCase())
    //Get a list of positive terms
        val PosFile = "/home/training/Spark_Attack/PositiveWords.txt"
        val PosSet = Source.fromFile(PosFile).getLines.toList
      val PosTerm = PosSet.map(line =>line.toLowerCase())
    //Get a list of positive terms
        val NegFile = "/home/training/Spark_Attack/NegativeWords.txt"
        val NegSet = Source.fromFile(NegFile).getLines.toList
        val NegTerm = NegSet.map(line =>line.toLowerCase())


        //Remove any tweets with empty text tweets, that are sensitive tweets and don't specify english as lang
        val nonNullStream = stream.filter(tweet =>
            tweet.getText().trim().length() > 0 &&
            ! tweet.isPossiblySensitive() &&
            tweet.toString().contains("lang=\'en\'")
        );



//Cleans up the streaming tweets and widen net to happy and sad emoticons
        val tweetText = nonNullStream.flatMap(line =>line.getText().toLowerCase().replaceAll("\\Q:)\\E|\\Q:D\\E|\\Q;')\\E|\\Q:-)\\E|\\Q:o)\\E|\\Q:]\\E|\\Q:3\\E|\\Q:c)\\E|\\Q:>\\E|\\Q=]\\E|\\Q:}\\E|\\Q:^)\\E|\\Q:???)\\E", "smiley").replaceAll("\\Q>:[\\E|\\Q:-(\\E|\\Q:(\\E|\\Q:-c\\E|\\Q:c\\E|\\Q:-<\\E|\\Q:???C\\E|\\Q:<\\E|\\Q:-[\\E|\\Q:[\\E|\\Q:{\\E|\\Q;(\\E|\\Q:-||\\E|\\Q:@\\E|\\Q>:(\\E", "sadface").replaceAll("[^a-z ]","").split("\\s"))

//Normal map to get RDDs of many incomming tweets
        val tweetsOnly = nonNullStream.map(line => line.getText().toLowerCase().replaceAll("\\Q:)\\E|\\Q:D\\E|\\Q;')\\E|\\Q:-)\\E|\\Q:o)\\E|\\Q:]\\E|\\Q:3\\E|\\Q:c)\\E|\\Q:>\\E|\\Q=]\\E|\\Q:}\\E|\\Q:^)\\E|\\Q:???)\\E", "smiley").replaceAll("\\Q>:[\\E|\\Q:-(\\E|\\Q:(\\E|\\Q:-c\\E|\\Q:c\\E|\\Q:-<\\E|\\Q:???C\\E|\\Q:<\\E|\\Q:-[\\E|\\Q:[\\E|\\Q:{\\E|\\Q;(\\E|\\Q:-||\\E|\\Q:@\\E|\\Q>:(\\E", "sadface").replaceAll("[^a-z ]",""))


//Creates an RDD of tweets containing references to Company List
val AppRDD = tweetsOnly.filter(RDD => AppTerm.count(RDD.contains(_))>0)
val apptweets = AppRDD.foreachRDD((rdd, time) => {
  val compCount = rdd.count()
  if (compCount > 0) {
    val outputRDD = rdd.repartition(3)
    outputRDD.saveAsTextFile(
      "/home/training/log" + "/App_tweets_" + time.milliseconds.toString)
   //  numTweetsCollected += count
   // if (numTweetsCollected > 20) {
   //   System.exit(0)
   // }
  }
})


val ApprenticeTweets= tweetText.filter(line => AppTerm.count(line.contains(_))>0).filter(line => AppTerm.count(line.contains(_))>0)


// Filter on positive reference to get count output
val PosCounts= ApprenticeTweets.filter(line => PosTerm.count(line.contains(_))>0)
val PosReduce = PosCounts.map(x => (x,1)).reduceByKey((x,y) => x+y)
val PosSortedList = PosReduce.map(pair => pair.swap).transform(rdd => rdd.sortByKey(false))
//PosSortedList.print()
PosSortedList.saveAsTextFiles("/home/training/log" +"/Positive_Counts")
val TotalPosCounts = PosReduce.map{case (x,y) => ("positive count",y)}.reduceByKey((x,y) => x+y)
TotalPosCounts.print()
//Save the total counts
TotalPosCounts.saveAsTextFiles("/home/training/log" +"/Total_Positive_Counts")
        

//Filter on negative reference to get count output
val NegCounts= ApprenticeTweets.filter(line => NegTerm.count(line.contains(_))>0) 
val NegReduce = NegCounts.map(x => (x,1)).reduceByKey((x,y) => x+y)
val NegSortedList = NegReduce.map(pair => pair.swap).transform(rdd => rdd.sortByKey(false))
//NegSortedList.print()
NegSortedList.saveAsTextFiles("/home/training/log" +"/Negative_Counts")
val TotalNegCounts = NegReduce.map{case (x,y) => ("negative count",y)}.reduceByKey((x,y) => x+y)
//Save the total counts
TotalNegCounts.saveAsTextFiles("/home/training/log" +"/Total_Negative_Counts")
TotalNegCounts.print()



//val sc = ssc.sparkContext 
//val accum = sc.accumulator(0)

//TotalPosCounts.foreach(y => accum += y)

//accum.print()



//If you want to create an RDD of positive tweets
//val PositiveRDD = tweetsOnly.filter(RDD => PosTerm.count(RDD.contains(_))>0)
//val PosRDDtweets = PositiveRDD.foreachRDD((rdd, time) => {
//  val posCount = rdd.count()
//  if (posCount > 0) {
   // val outputRDD = rdd.repartition(3)
  //  outputRDD.saveAsTextFile(
      //"/home/training/log" + "/Positive_tweets_" + time.milliseconds.toString + posCount)
   //  numTweetsCollected += count
   // if (numTweetsCollected > 20) {
   //   System.exit(0)
   // }
 // }
//})

//If you want to create an RDD of Negative tweets
//val NegRDD = tweetsOnly.filter(RDD => NegTerm.count(RDD.contains(_))>0)
//val NegRDDtweets = NegRDD.foreachRDD((rdd, time) => {
 // val negCount = rdd.count()
 // if (negCount > 0) {
   // val outputRDD = rdd.repartition(3)
   // outputRDD.saveAsTextFile(
     // "/home/training/log" + "/Negtive_tweets_" + time.milliseconds.toString + negCount)
   //  numTweetsCollected += count
   // if (numTweetsCollected > 20) {
   //   System.exit(0)
   // }
//  }
//})


    //  val initialRDD = ssc.sparkContext.parallelize(List((searchTerm, 0)))

    //  val wordDstream = tweetText.map(x => (x,1)).reduceByKey((x,y)=>x+y)
    //  val wordList = wordDstream.map(pair => pair.swap).transform(rdd => rdd.sortByKey(false))
        //val stateDstream = wordDstream.updateStateByKey[Int](newUpdateFunc, new HashPartitioner (ssc.sparkContext.defaultParallelism), true, initialRDD)
        //stateDstream.print(20)

    //  wordList.print(20)
    //  val stateDstream = wordList

    //  stateDstream.saveAsTextFiles("/home/training/log/Stream.txt")


        ssc.start()
        ssc.awaitTermination()
    }
}

                     
