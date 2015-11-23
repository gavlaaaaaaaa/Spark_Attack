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


	// Get a list of company names to filter tweets on	
		val CompanyFile = "/home/training/FTSE100.txt"
		val searchSet = Source.fromFile(CompanyFile).getLines.toList
		val CompTerm = searchSet.map(line =>line.toLowerCase())
	//Get a list of positive terms
		val PosFile = "/home/training/PositiveWords.txt"
		val PosSet = Source.fromFile(PosFile).getLines.toList
		val PosTerm = PosSet.map(line =>line.toLowerCase())
	//Get a list of positive terms
		val NegFile = "/home/training/NegativeWords.txt"
		val NegSet = Source.fromFile(NegFile).getLines.toList
		val NegTerm = NegSet.map(line =>line.toLowerCase())


		//Remove any tweets with empty text tweets, that are sensitive tweets and don't specify english as lang
		val nonNullStream = stream.filter(tweet =>
			tweet.getText().trim().length() > 0 &&
			! tweet.isPossiblySensitive() &&
			tweet.toString().contains("lang=\'en\'") 
		);
	//	val CompanyTweet= nonNullStream.filter(RDD => searchTerm.count(RDD.contains(_)) >0) 
			
	
	//	val tweetText = nonNullStream.flatMap(line =>line.getText().toLowerCase().replaceAll("[^a-z ]","").replaceAll(searchTerm,"").split("\\s"))
	
//Cleans up the streaming tweets
		val tweetText = nonNullStream.flatMap(line =>line.getText().toLowerCase().replaceAll("\\Q:)\\E|\\Q:D\\E|\\Q;')\\E|\\Q:-)\\E|\\Q:o)\\E|\\Q:]\\E|\\Q:3\\E|\\Q:c)\\E|\\Q:>\\E|\\Q=]\\E|\\Q:}\\E|\\Q:^)\\E|\\Q:???)\\E", "smiley").replaceAll("[^a-z ]","").split("\\s"))


//Normal map to get RDDs of many incomming tweets	
		val tweetsOnly = nonNullStream.map(line => line.getText().toLowerCase().replaceAll("\\Q:)\\E|\\Q:D\\E|\\Q;')\\E|\\Q:-)\\E|\\Q:o)\\E|\\Q:]\\E|\\Q:3\\E|\\Q:c)\\E|\\Q:>\\E|\\Q=]\\E|\\Q:}\\E|\\Q:^)\\E|\\Q:???)\\E", "smiley").replaceAll("[^a-z ]",""))


//Creates an RDD of tweets containing references to Company List
val CompanyRDD = tweetsOnly.filter(RDD => CompTerm.count(RDD.contains(_))>0)
val CompRDDtweets = CompanyRDD.foreachRDD((rdd, time) => {
  val count = rdd.count()
  if (count > 0) {
    val outputRDD = rdd.repartition(3)
    outputRDD.saveAsTextFile(
      "/home/training/log" + "/Company_tweets_" + time.milliseconds.toString)
   //  numTweetsCollected += count
   // if (numTweetsCollected > 20) {
   //   System.exit(0)
   // }
  }
})

//Creates an RDD of positive tweets
val PositiveRDD = tweetsOnly.filter(RDD => PosTerm.count(RDD.contains(_))>0)
val PosRDDtweets = PositiveRDD.foreachRDD((rdd, time) => {
  val count = rdd.count()
  if (count > 0) {
    val outputRDD = rdd.repartition(3)
    outputRDD.saveAsTextFile(
      "/home/training/log" + "/Positive_tweets_" + time.milliseconds.toString)
   //  numTweetsCollected += count
   // if (numTweetsCollected > 20) {
   //   System.exit(0)
   // }
  }
})

//Creates an RDD of Negative tweets
val NegRDD = tweetsOnly.filter(RDD => NegTerm.count(RDD.contains(_))>0)
val NegRDDtweets = NegRDD.foreachRDD((rdd, time) => {
  val count = rdd.count()
  if (count > 0) {
    val outputRDD = rdd.repartition(3)
    outputRDD.saveAsTextFile(
      "/home/training/log" + "/Negtive_tweets_" + time.milliseconds.toString)
   //  numTweetsCollected += count
   // if (numTweetsCollected > 20) {
   //   System.exit(0)
   // }
  }
})
	
			
	//	val n = 3
	//	val ngrams = (for( i <- 1 to n) yield tweetText.sliding(i).map(p => p.toList)).flatMap(x=>x).groupBy(x=>x).mapValues{_.size}
//import ListMap function to order by the count
//import scala.collection.immutable.ListMap
//val ngramsList = ListMap(ngrams.toSeq.sortWith(_._2 > _._2):_*)

		
	//	val initialRDD = ssc.sparkContext.parallelize(List((searchTerm, 0)))

		val wordDstream = tweetText.map(x => (x,1)).reduceByKey((x,y)=>x+y)
		val wordList = wordDstream.map(pair => pair.swap).transform(rdd => rdd.sortByKey(false))
		//val stateDstream = wordDstream.updateStateByKey[Int](newUpdateFunc, new HashPartitioner (ssc.sparkContext.defaultParallelism), true, initialRDD)
		//stateDstream.print(20)

		wordList.print(20)
		val stateDstream = wordList
		
	//	stateDstream.saveAsTextFiles("/home/training/log/Stream.txt")
		

		ssc.start()
		ssc.awaitTermination()
	}
}

