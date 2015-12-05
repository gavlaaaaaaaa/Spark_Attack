<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
	<title>Word Clouds</title>
	<meta content="text/html; charset=UTF-8" http-equiv="Content-Type">
	<meta name="viewport" content="width=device-width, initial-scale=1">
	
	<link rel="stylesheet" href="bootstrap-3.3.5-dist/css/bootstrap.min.css">
	<link rel="stylesheet" href="general.css">
	
	<script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.1/jquery.min.js"></script>
	<script src="bootstrap-3.3.5-dist/js/bootstrap.min.js"></script>
	<script src="d3/d3.min.js"></script>
	<script src="javascript/basic.js"></script>
	<script src="javascript/jquery-1.11.3.min.js"></script>

	<style>
		.bg-1 {
			background: #2d2d30;
			color: #bdbdbd;
		}

		.bg-4 { 
			background-color: #2f2f2f;
			color: #fff;
		}
		
		.svg-container {
			display: inline-block;
			position: relative;
			width: 100%;
			height:500px;
			padding-bottom: 30%; /* aspect ratio */
			vertical-align: top;
			overflow: hidden;
			background: #ffffff;
			//background: #2d1f2a;
		}
		.svg-content-responsive {
			display: inline-block;
			position: absolute;
			top: 10px;
			left: 0;
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


	<div class="svg-container" id="svgg">
	</div>
	

	<div class="bg-1" style="padding-top: 60px; padding-bottom: 100px; padding-left: 60px; padding-right: 60px">
		<!-- form role="form" action="WordCloud" method="post"-->
		<form role="form" id="sparkSearch"> <!--  onsubmit="myFunc"-->
			
			<div class="col-lg-5 ">
				<input type="text" class="form-control" id="searchTerms" name="searchTerms" placeholder="Search for..." >
			</div>
			<div class="col-lg-2 " style="height:100%;margin-bottom:2em;margin-top:-2em;">
				<button class="btn btn-primary btn-lg center-block" type="submit" id="submit_btn" style="width:6em;height:6em;border-radius: 3em;border: 2px solid #66657f;"></button>
			</div>
			<div class="col-lg-5" >
				<select class="form-control" id="sparkSource" name="sparkSource">
					<option>Twitter</option>
					<option>Voice</option>
				</select>
			</div>
		</form>
	</div>


	<div class="container">
		<p id="displayName"></p>
		<h2>Generating Word Clouds</h2>
		<h4>
			We generate the <i>"word clouds"</i> using Spark streaming with Twitter. Entering a word and clicking search causes a new Spark Job to start.
			The Spark Job runs in the cluster and connects to Twitter. We use discretized streams (DStreams) which accumulates 10 seconds worth of Tweets
			from Twitter. Tweets are returned as a number of JSON objects. We perform a clean and normalise on each JSON object by:
			<br><br>
			<ul>
				<li>Filtering on Tweets that contain the search word</li>
				<li>Removing null values</li>
				<li>Filtering English using <i>en</i> tag</li>
				<li>Removing Stop Words e.g. and, or</li>
				<li>Changing to upper case</li>
				<li>Removing non-alpha characters</li>
			</ul>
			<br>
			We then perform a summation of all words and take the highest 50.
		</h4>
	</div>


	<footer class="footer">
		<div class="container">
			<p>Created for Tech Challenge at <a href="https://www.uk.capgemini.com">Capgemini</a></p>
		</div>
	</footer>
	
</body>
</html>