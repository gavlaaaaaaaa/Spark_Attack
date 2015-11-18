package org.apache.spark.examples.streaming

import org.apache.spark.streaming.{Seconds, StreamingContext}
import org.apache.spark.SparkContext._
import org.apache.spark.streaming.twitter._
import org.apache.spark.SparkConf
import org.apache.spark.HashPartitioner



import org.apache.log4j.Logger
import org.apache.log4j.Level
import org.apache.spark.storage.StorageLevel


object TopWords {
	def main(args: Array[String]) {
		if (args.length < 5) {
			System.err.println("Usage: TwitterPopularTags <consumer key> <consumer secret> <access token> <access token secret> <search-term>")
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


		val searchTerm = args(4).toLowerCase()
		val Array(consumerKey, consumerSecret, accessToken, accessTokenSecret) = args.take(4)

		val tokens = args.takeRight(args.length - 4)


		System.setProperty("twitter4j.oauth.consumerKey", consumerKey)
		System.setProperty("twitter4j.oauth.consumerSecret", consumerSecret)
		System.setProperty("twitter4j.oauth.accessToken", accessToken)
		System.setProperty("twitter4j.oauth.accessTokenSecret", accessTokenSecret)


		val sparkConf = new SparkConf().setAppName("Top Words")
		val ssc = new StreamingContext(sparkConf, Seconds(10))

		ssc.checkpoint(".")

		val stream = TwitterUtils.createStream(ssc, None, tokens)


		stream.persist(StorageLevel.MEMORY_ONLY)


		//Remove any tweets with empty text tweets, that are sensitive tweets and don't specify english as lang
		val nonNullStream = stream.filter(tweet =>
			tweet.getText().trim().length() > 0 &&
			! tweet.isPossiblySensitive() &&
			tweet.toString().contains("lang=\'en\'") &&
			tweet.toString().contains(searchTerm)
		);


		val tweetText = nonNullStream.flatMap(line =>line.getText().toLowerCase().replaceAll("[^a-z ]","").replaceAll(searchTerm,"").split("\\s"))


		val initialRDD = ssc.sparkContext.parallelize(List((searchTerm, 0)))
	
		val wordDstream = tweetText.map(x => (x, 1))

		val stateDstream = wordDstream.updateStateByKey[Int](newUpdateFunc, new HashPartitioner (ssc.sparkContext.defaultParallelism), true, initialRDD)
		stateDstream.print(20)
		ssc.start()
		ssc.awaitTermination()
	}
}

