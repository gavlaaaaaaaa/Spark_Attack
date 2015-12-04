<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html lang="en">
<head>
	<title>Spark Attack</title>
	<meta content="text/html; charset=UTF-8" http-equiv="Content-Type">
	<meta name="viewport" content="width=device-width, initial-scale=1">
	
	<link rel="stylesheet" href="bootstrap-3.3.5-dist/css/bootstrap.min.css">
	<link rel="stylesheet" href="general.css">
	
	<script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.1/jquery.min.js"></script>
	<script src="bootstrap-3.3.5-dist/js/bootstrap.min.js"></script>
	<!-- script src=”jquery.mobile-1.4.5/jquery.mobile.custom.min.js”></script-->  
	
	
	<style>
		.person {
			border: 10px solid transparent;
			margin-bottom: 25px;
			width: 100%;
			height: 100%;
			opacity: 0.7;
		}

		.person:hover {border-color: #f1f1f1;}

		.bg-1 {
			background: #2d2d30;
			color: #bdbdbd;
		}
		
		.bg-4 { 
			background-color: #2f2f2f;
			color: #fff;
		}

		.carousel-caption {
			width: 100%;
			top: 80% !important;
			left: 0%;
			transform: translateX(0%);
			text-align: center;bottom: initial;
			padding-bottom:200px;
			padding-top:0px;
		}
		
		.meetteam {
			padding-top: 30px;
			padding-bottom: 30px;
		}
		
		.person-name {
			margin-top:40px;
			font: 16px sans-serif;
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




	<!-- div id="myCarousel" class="carousel slide" data-ride="carousel"-->
	<div id="myCarousel" class="carousel slide" data-ride="carousel">
		<!-- Indicators -->
		<ol class="carousel-indicators">
			<li data-target="#myCarousel" data-slide-to="0" class="active"></li>
			<li data-target="#myCarousel" data-slide-to="1"></li>
			<li data-target="#myCarousel" data-slide-to="2"></li>
			<li data-target="#myCarousel" data-slide-to="3"></li>
		</ol>

		<!-- Wrapper for slides -->
		<div class="carousel-inner" role="listbox">
			<div class="item active" style="background-color:black;">
				<center>
					<a href="ProvidingInsights.jsp" ><img src="images/sparkler.jpg" alt="Providing Insights" width="960" height="610" align="middle"></a>
				</center>
				<div class="carousel-caption">
					<h3>Providing Data Insights</h3>
					<p>Find out how we provide insights into big data.</p>
				</div>
			</div>
			<div class="item">
				<center>
					<a href="WordClouds.jsp"><img src="images/word_cloud.jpg" alt="Word Clouds" width="960" height="610" ></a>
				</center>
				<div class="carousel-caption" style="background-color:black;">
					<h3>Word Clouds</h3>
					<p>Find common words and themes associated to a company.</p>
				</div>
			</div>

			<div class="item">
				<center>
					<a href="SentimentAnalysis.jsp"><img src="images/sentiment_analysis.jpg" alt="Sentiment Analysis" width="960" height="610" ></a>
				</center>
				<div class="carousel-caption" style="background-color:black;">
					<h3>Sentiment Analysis</h3>
					<p>Compare the sentiment between companies.</p>
				</div>      
			</div>

			<div class="item">
				<center>
					<a href="DiscoveringRelationships.jsp"><img src="images/discover_relationships.jpg" alt="Discovering Relationships" width="960" height="610" ></a>
				</center>
				<div class="carousel-caption" style="background-color:black;">
					<h3>Discovering Relationships</h3>
					<p>Find connections between companies.</p>
				</div>      
			</div>
		</div>

		<!-- Left and right controls -->
		<a class="left carousel-control" href="#myCarousel" role="button" data-slide="prev">
			<span class="glyphicon glyphicon-chevron-left" aria-hidden="true"></span>
			<span class="sr-only">Previous</span>
		</a>
		<a class="right carousel-control" href="#myCarousel" role="button" data-slide="next">
			<span class="glyphicon glyphicon-chevron-right" aria-hidden="true"></span>
			<span class="sr-only">Next</span>
		</a>
	</div>

<!-- script type="text/javascript" async="" src="slider-swipe_files/ga.js"></script><script src="slider-swipe_files/jquery.min.js"></script>
    <script src="slider-swipe_files/bootstrap-carousel.js"></script>
    <script src="slider-swipe_files/jquery.mobile.custom.min.js"></script-->
    <script>
    /*
    $(document).ready(function() {
		    $("#myCarousel").swiperight(function() {
		    	$("#myCarousel").carousel('prev');
		    });
		    $("#myCarousel").swipeleft(function() {
		    	$("#myCarousel").carousel('next');
		    });
			
    });
    */
    </script>



	<div class="bg-1 meetteam">
		<div class="container text-center">
			<h2><em>Meet the team...</em></h2>
			</br>
		</div>
	</div>


	<div class="container text-center">

		<div class="row">
			<div class="col-sm-3">
				<p class="text-center person-name"><strong>David Hayes</strong></p><br>
				<a href="#drop" data-toggle="collapse">
					<img src="images/profile.jpg" class="img-circle person" alt="Random Name">
				</a>
   				<div id="drop" class="collapse">
					<p>Senior Architect</p>
					<p>EDH Data Acquisition</p>
					<p>Since 2014</p>
				</div>
			</div>
			<div class="col-sm-3">
				<p class="text-center person-name"><strong>Hayden Mills</strong></p><br>
				<a href="#drop2" data-toggle="collapse">
					<img src="images/profile.jpg" class="img-circle person" alt="Random Name">
				</a>
				<div id="drop2" class="collapse">
					<p>Software Engineer</p>
					<p>EDH Data Acquisition</p>
					<p>Since 2014</p>
				</div>
			</div>
			<div class="col-sm-3">
				<p class="text-center person-name"><strong>Leah Tarbuck</strong></p><br>
				<a href="#drop3" data-toggle="collapse">
					<img src="images/profile.jpg" class="img-circle person" alt="Random Name">
				</a>
				<div id="drop3" class="collapse">
					<p>Software Engineer</p>
					<p>EDH Data Acquisition</p>
					<p>Since 2014</p>
				</div>
			</div>
			<div class="col-sm-3">
				<p class="text-center person-name"><strong>Lewis Gavin</strong></p><br>
				<a href="#drop4" data-toggle="collapse">
					<img src="images/profile.jpg" class="img-circle person" alt="Random Name">
				</a>
				<div id="drop4" class="collapse">
					<p>Software Engineer</p>
					<p>EDH Data Acquisition</p>
					<p>Since 2014</p>
				</div>
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