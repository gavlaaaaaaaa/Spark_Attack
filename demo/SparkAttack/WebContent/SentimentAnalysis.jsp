<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html lang="en">
<head>
	<title>Sentiment Analysis</title>
	<meta content="text/html; charset=UTF-8" http-equiv="Content-Type">
	<meta name="viewport" content="width=device-width, initial-scale=1">
	
	<link rel="stylesheet" href="bootstrap-3.3.5-dist/css/bootstrap.min.css">
	<link rel="stylesheet" href="general.css">
	
	<script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.1/jquery.min.js"></script>
	<script src="bootstrap-3.3.5-dist/js/bootstrap.min.js"></script>
	<script src="d3/d3.min.js"></script>
	
	<style>
		.bg-1 {
			background: #2d2d30;
			color: #bdbdbd;
		}

		.bg-4 { 
			background-color: #2f2f2f;
			color: #fff;
		}

		text {
			font: 10px sans-serif;
		}

		.axis path,
		.axis line {
			fill: none;
			stroke: #000;
			shape-rendering: crispEdges;
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



	<form style="margin-top: 60px; margin-right: 20px;" align="right">
		<label><input type="radio" name="mode" value="grouped"> Grouped</label>
		<label><input type="radio" name="mode" value="stacked" checked=""> Stacked</label>
	</form>






	<script>

		var n = 4, // number of layers
			m = 58, // number of samples per layer
			stack = d3.layout.stack(),
			layers = stack(d3.range(n).map(function() { return bumpLayer(m, .1); })),
			yGroupMax = d3.max(layers, function(layer) { return d3.max(layer, function(d) { return d.y; }); }),
			yStackMax = d3.max(layers, function(layer) { return d3.max(layer, function(d) { return d.y0 + d.y; }); });

		var margin = {top: 40, right: 20, bottom: 20, left: 20},
			width = screen.width - margin.left - margin.right,
			height = 500 - margin.top - margin.bottom;

		var x = d3.scale.ordinal()
			.domain(d3.range(m))
			.rangeRoundBands([0, width], .08);

		var y = d3.scale.linear()
			.domain([0, yStackMax])
			.range([height, 0]);

		var color = d3.scale.linear()
			.domain([0, n - 1])
			.range(["#8AD17B","#DB818D"]);

		var xAxis = d3.svg.axis()
			.scale(x)
			.tickSize(0)
			.tickPadding(6)
			.orient("bottom");

		var svg = d3.select("body").append("svg")
			.attr("width", width + margin.left + margin.right)
			.attr("height", height + margin.top + margin.bottom)
			.append("g")
			.attr("transform", "translate(" + margin.left + "," + margin.top + ")");


		var layer = svg.selectAll(".layer")
			.data(layers)
			.enter().append("g")
			.attr("class", "layer")
			.style("fill", function(d, i) { return color(i); });

		var rect = layer.selectAll("rect")
			.data(function(d) { return d; })
			.enter().append("rect")
			.attr("x", function(d) { return x(d.x); })
			.attr("y", height)
			.attr("width", x.rangeBand())
			.attr("height", 0);

		rect.transition()
			.delay(function(d, i) { return i * 10; })
			.attr("y", function(d) { return y(d.y0 + d.y); })
			.attr("height", function(d) { return y(d.y0) - y(d.y0 + d.y); });

		svg.append("g")
			.attr("class", "x axis")
			.attr("transform", "translate(0," + height + ")")
			.call(xAxis);

		d3.selectAll("input").on("change", change);

		var timeout = setTimeout(function() {
			d3.select("input[value=\"grouped\"]").property("checked", true).each(change);
		}, 2000);

		function change() {
			clearTimeout(timeout);
			if (this.value === "grouped") transitionGrouped();
			else transitionStacked();
		}

		function transitionGrouped() {
			y.domain([0, yGroupMax]);

			rect.transition()
			.duration(500)
			.delay(function(d, i) { return i * 10; })
			.attr("x", function(d, i, j) { return x(d.x) + x.rangeBand() / n * j; })
			.attr("width", x.rangeBand() / n)
			.transition()
				.attr("y", function(d) { return y(d.y); })
				.attr("height", function(d) { return height - y(d.y); });
		}

		function transitionStacked() {
			y.domain([0, yStackMax]);

			rect.transition()
				.duration(500)
				.delay(function(d, i) { return i * 10; })
				.attr("y", function(d) { return y(d.y0 + d.y); })
				.attr("height", function(d) { return y(d.y0) - y(d.y0 + d.y); })
				.transition()
					.attr("x", function(d) { return x(d.x); })
					.attr("width", x.rangeBand());
		}

		function bumpLayer(n, o) {

			function bump(a) {
				var x = 1 / (.1 + Math.random()),
					y = 2 * Math.random() - .5,
					z = 10 / (.1 + Math.random());
				for (var i = 0; i < n; i++) {
					var w = (i / n - y) * z;
					a[i] += x * Math.exp(-w * w);
				}
			}

			var a = [], i;
			for (i = 0; i < n; ++i) a[i] = o + o * Math.random();
			for (i = 0; i < 5; ++i) bump(a);
			return a.map(function(d, i) { return {x: i, y: Math.max(0, d)}; });
		}

	</script>



	<div class="bg-1" style="padding-top: 60px; padding-bottom: 60px;">
		<div class="row">
			<div class="col-lg-6" style="width:80%;margin-left: 10%; margin-right: 10%;">
				<div class="input-group">
					<input type="text" class="form-control" placeholder="Search for...">
					<span class="input-group-btn">
						<button class="btn btn-default" type="button"><span class="glyphicon glyphicon-search"></span></button>
					</span>
				</div>
			</div>
		</div>
	</div>

	<div class="bg-2">
		<div class="container">
			<h2>Explaination Here</h2>
			<h3>





			</h3>
			</br>
		</div>
	</div>

	<footer class="footer">
		<div class="container">
			<p>Created for Tech Challenge at <a href="https://www.uk.capgemini.com">Capgemini</a></p>
		</div>
	</footer>
</body>
</html>