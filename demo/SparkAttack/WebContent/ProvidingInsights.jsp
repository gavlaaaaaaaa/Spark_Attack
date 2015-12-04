<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html lang="en">
<head>
	<title>Providing Insights</title>
	<meta content="text/html; charset=UTF-8" http-equiv="Content-Type">
	<meta name="viewport" content="width=device-width, initial-scale=1">
	
	<link rel="stylesheet" href="bootstrap-3.3.5-dist/css/bootstrap.min.css">
	<link rel="stylesheet" href="general.css">
	
	<script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.1/jquery.min.js"></script>
	<script src="bootstrap-3.3.5-dist/js/bootstrap.min.js"></script>
	
	
	<style>
		.bg-1 {
			background: #2d2d30;
			color: #bdbdbd;
		}
		
		.bg-1 { 
			background-color: #1abc9c;
			color: #ffffff;
		}
		.bg-2 { 
			background-color: #474e5d;
			color: #ffffff;
		}
		.bg-3 { 
			background-color: #ffffff;
			color: #555555;
		}
		.bg-4 { 
			background-color: #2f2f2f;
			color: #fff;
		}
	</style>
</head>


<body>
	<nav class="navbar navbar-default navbar-fixed-top">
		<div class="container-fluid">
			<div class="navbar-header">
				<button type="button" class="navbar-toggle" data-toggle="collapse" data-target="#myNavbar">
					<span class="icon-bar"></span>
					<span class="icon-bar"></span>
					<span class="icon-bar"></span> 
				</button>
				<a class="navbar-brand" href="SparkAttack.jsp">Spark Attack</a>
			</div>
			<div class="collapse navbar-collapse" id="myNavbar">
				<ul class="nav navbar-nav navbar-right">
					<li><a href="SparkAttack.jsp">HOME</a></li>
					<li class="dropdown">
						<a class="dropdown-toggle" data-toggle="dropdown">
							<span class="glyphicon glyphicon-th-list"></span>
						</a>
						<ul class="dropdown-menu">
							<li><a href="ProvidingInsights.jsp">Providing Insights</a></li>
							<li><a href="WordClouds.jsp">Word Clouds</a></li>
							<li><a href="SentimentAnalysis.jsp">Sentiment Analysis</a></li>
							<li><a href="DiscoveringRelationships.jsp">Discovering Relationships</a></li> 
						</ul>
					</li>
				</ul>
			</div>
		</div>
	</nav>



	<div class="container-fluid bg-1 text-center" style="margin-top: 50px;">
		<h3>How do we do it?</h3>
		<img src="images/spark_logo.jpg" class="img-responsive img-circle" style="display:inline" alt="Bird" width="350" height="350">
		<h3>...of course</h3>
	</div>

	<div class="container-fluid bg-2 text-center" style="padding-bottom: 30px;">
		<h3>What is Spark?</h3>
		<p>Apache Spark is a fast and general engine for large-scale data processing.</p>
		<a href="http://spark.apache.org/" class="btn btn-default btn-lg">
			<span class="glyphicon glyphicon-search"></span> Search
		</a>
	</div>

	<div class="container-fluid bg-3 text-center">    
		<h3>About Spark</h3><br>
		<div class="row">
			<div class="col-sm-4">
				<h4>Speed</h4>
				<p>Run programs up to 100x faster than Hadoop MapReduce in memory, or 10x faster on disk.</p>
				<img src="images/logistic_regression.jpg" class="img-responsive center-block" style="width:200px" alt="Image">
			</div>
			<div class="col-sm-4">
				<h4>Ease of Use</h4>
				<p>Write applications quickly in Java, Scala, Python, R. Combines SQL, streaming, and complex analytics.</p>
				<img src="images/spark_stack.jpg" class="img-responsive center-block" style="width:200px" alt="Image">
			</div>
			<div class="col-sm-4">
				<h4>Runs Everywhere</h4>
				<p>Spark runs on Hadoop, Mesos, standalone, or in the cloud. It can access diverse data sources including HDFS, Cassandra, HBase, and S3.</p>
				<img src="images/hadoop_logo.jpg" class="img-responsive center-block"" style="width:200px" alt="Image">
			</div>
		</div>
	</div>

	<footer class="footer">
		<div class="container">
			<p>Created for Tech Challenge at <a href="https://www.uk.capgemini.com">Capgemini</a></p>
		</div>
	</footer>
</body>
</html>