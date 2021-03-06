package scala

import org.apache.spark.streaming.{Seconds, StreamingContext}
import org.apache.spark.SparkContext._
import org.apache.spark.streaming.twitter._
import org.apache.spark.SparkConf
import org.apache.spark.HashPartitioner
import org.apache.spark.rdd._

import org.apache.spark.streaming.dstream.TransformedDStream

import org.apache.log4j.Logger
import org.apache.log4j.Level
import org.apache.spark.storage.StorageLevel

import java.net._
import java.io._
import scala.io._

import scala.io.Source



package object streaming {

	val sourcePos : InputStream = getClass.getResourceAsStream("/PositiveWords.txt")
	val positiveWords : Array[String] = scala.io.Source.fromInputStream(sourcePos).mkString.split("\n")

	val sourceNeg : InputStream = getClass.getResourceAsStream("/NegativeWords.txt")
	val negativeWords : Array[String] = scala.io.Source.fromInputStream(sourceNeg).mkString.split("\n")		

	val sourceHappyEmoji : InputStream = getClass.getResourceAsStream("/HappyEmoticons.txt")
	val happyEmojiWords : Array[String] = scala.io.Source.fromInputStream(sourceHappyEmoji).mkString.split("\n")	

	val sourceSadEmoji : InputStream = getClass.getResourceAsStream("/SadEmoticons.txt")
	val sadEmojiWords : Array[String] = scala.io.Source.fromInputStream(sourceSadEmoji).mkString.split("\n")	

	val sourceProf : InputStream = getClass.getResourceAsStream("/Profanity.txt")
	val profanityWords : Array[String] = scala.io.Source.fromInputStream(sourceProf).mkString.split("\n")
	
	val source : InputStream = getClass.getResourceAsStream("/StopWords.txt")
	val stopWords : Array[String] = scala.io.Source.fromInputStream(source).mkString.split("\n")


 val updateFunc = (values: Seq[Int], state: Option[Int]) => {
        val currentCount = values.sum
        val previousCount = state.getOrElse(0)

        Some(currentCount + previousCount)
    }

    val newUpdateFunc = (iterator: Iterator[(String, Seq[Int], Option[Int])]) => {
        iterator.flatMap(t => updateFunc(t._2, t._3).map(s => (t._1, s)))
    }


/*
	*  Takes a string a words within that string to search for. These words are replaced
	*  with replacement string.
	*/
	def replaceWords(line:String, searchWords:Array[String], replacement:String) : String = {
		var result = line

		for (word <- searchWords) {
			result = result.replace(word,replacement)
		}
		return result
	}


	/*
	*  Takes a tuple (string, int)  - word and count. Returns a tuple (string, int, string) - word, count and classification of word.
	*/
	def classify(wordCounts:(String,Int), goodWords:Array[String], badWords:Array[String]) : (String, Int, String) = {
		if(goodWords.contains(wordCounts._1)) {
			return (wordCounts._1,wordCounts._2,"g")
		}
		else if(badWords.contains(wordCounts._1)) {
			return (wordCounts._1,wordCounts._2,"b")
		}
		else {
			return (wordCounts._1,wordCounts._2,"n")
		}
	}



	/*
	*  Takes a string and replaces any profanity or stop words.
	*/
	def replaceUnwantedWords(message:String) : String = {
		var result = message

		//Replace all stop words
		for (stopWord <- stopWords) {
			result = result.replaceAll("\\b" + stopWord + "\\b","")
		}
		//Replace all profanity words
		for (profanityWord <- profanityWords) {
			result = result.replaceAll("\\b" + profanityWord + "\\b","profanity")
		}
		//Remove any retweet tags
		result = result.replaceAll("\\brt\\b","")
		//Remove any URIs
		result = result.replaceAll("\\bhttp[^\\s]*\\b","")
		result = result.replaceAll("\\s+"," ")
		result = result.trim()
		return result
	}


	/*
	*  Replaces happy and sad emoticons within a string and returns the resulting string with
	*  either "happyemoticon" or "sademoticon" in place.
	*/
	def replaceEmoticons(message:String) : String = {
		var result = message

		for (happy <- happyEmojiWords) {
			result = result.replace(happy,"happyemoticon")
		}
		for (sad <- sadEmojiWords) {
			result = result.replace(sad,"sademoticon")
		}

		return result
	}


	/*
	*  Put everything to lower case, alpha characters only.
	*/
	def normaliseMessage(message:String) : String = {
		var result = message

		result = result.toLowerCase()
		result = result.replaceAll("[^a-z\\s]","")

		return result
	}

	/*
	*  Takes a tuple (string, int)  - word and count. Returns a tuple (string, int, string) - word, count and classification of word.
	*/
	def addClassification(wordCounts:(String,Int)) : (String, Int, String) = {
		if(positiveWords.contains(wordCounts._1)) {
			return (wordCounts._1,wordCounts._2,"g")
		}
		else if(negativeWords.contains(wordCounts._1)) {
			return (wordCounts._1,wordCounts._2,"b")
		}
		else {
			return (wordCounts._1,wordCounts._2,"n")
		}
	}


	/*
	*  Classifies a message as good 'g', bad 'b' or neutral 'n' based on the amount of
	*  positive and negative words the message contains.
	*/
	def classifyMessage(message:String) : (String, String) = {
		var result = message

		//Replaces emoticons
		result = replaceEmoticons(result)
		//Changes case to lower case
		result = normaliseMessage(result)
		//Replaces profanities, stop words, URIs
		result = replaceUnwantedWords(result)


		var words = result.split("\\s")


		return (message,"n") //TODO don't always return neutral
	}

	/*
	*  Takes an rdd of tuples (string, int, string) - word,count,classification and outputs
	*  them to a given socket - IP & port
	*/
	def printRddWordCount(rdd:RDD[(String,Int,String)], ip:String, port:String) : Unit = {
		val socket = new Socket(InetAddress.getByName(ip), Integer.parseInt(port))
		val out = new PrintStream(socket.getOutputStream())
		var jsonOut = "{\"name\": \"flare\",\"children\":["

		rdd.foreach(item =>{
			jsonOut = jsonOut +  "{\"name\":\"" + item._1 +"\",\"size\": " + item._2 + ",\"type\":\"" + item._3 + "\"}"
			jsonOut = jsonOut + ","
		})

		jsonOut = jsonOut.replaceAll(",$","")
		jsonOut = jsonOut + "]}\n"
		
		out.println(jsonOut)
		out.flush()
		socket.close()
	}

	/*
	*  Takes an rdd of tuples (string, int, string) - classification,count,timestamp and outputs
	*  them to a given socket - IP & port
	*/
	def printMessageClassifications(rdd:RDD[(String,Int,String)], ip:String, port:String) : Unit = {
		val socket = new Socket(InetAddress.getByName(ip), Integer.parseInt(port))
		val out = new PrintStream(socket.getOutputStream())
		var jsonOut = "{\"name\": \"flare\",\"children\":["

		rdd.foreach(item =>{
			jsonOut = jsonOut +  "{\"class\":\"" + item._1 +"\",\"size\": " + item._2 + ",\"time\":\"" + item._3 + "\"}"
			jsonOut = jsonOut + ","
		})

		jsonOut = jsonOut.replaceAll(",$","")
		jsonOut = jsonOut + "]}\n"
		
		out.println(jsonOut)
		out.flush()
		socket.close()
	}

}


