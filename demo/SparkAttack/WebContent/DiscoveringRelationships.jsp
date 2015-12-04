<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html lang="en">
<head>
	<title>Discovering Relationships</title>
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

		.link {
			fill: none;
			stroke: #666;
			stroke-width: 1.5px;
		}

		#licensing {
			fill: green;
		}

		.link.licensing {
			stroke: green;
		}

		.link.resolved {
			stroke-dasharray: 0,2 1;
		}

		circle {
			fill: #ccc;
			stroke: #333;
			stroke-width: 1.5px;
		}

		text {
			font: 10px sans-serif;
			pointer-events: none;
			text-shadow: 0 1px 0 #fff, 1px 0 0 #fff, 0 -1px 0 #fff, -1px 0 0 #fff;
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



	<script>
		var links = [
		{source: "Microsoft", target: "Amazon", type: "licensing"},
		{source: "Microsoft", target: "HTC", type: "licensing"},
		{source: "Samsung", target: "Apple", type: "suit"},
		{source: "Motorola", target: "Apple", type: "suit"},
		{source: "Nokia", target: "Apple", type: "resolved"},
		{source: "HTC", target: "Apple", type: "suit"},
		{source: "Kodak", target: "Apple", type: "suit"},
		{source: "Microsoft", target: "Barnes & Noble", type: "suit"},
		{source: "Microsoft", target: "Foxconn", type: "suit"},
		{source: "Oracle", target: "Google", type: "suit"},
		{source: "Apple", target: "HTC", type: "suit"},
		{source: "Microsoft", target: "Inventec", type: "suit"},
		{source: "Samsung", target: "Kodak", type: "resolved"},
		{source: "LG", target: "Kodak", type: "resolved"},
		{source: "RIM", target: "Kodak", type: "suit"},
		{source: "Sony", target: "LG", type: "suit"},
		{source: "Kodak", target: "LG", type: "resolved"},
		{source: "Apple", target: "Nokia", type: "resolved"},
		{source: "Qualcomm", target: "Nokia", type: "resolved"},
		{source: "Apple", target: "Motorola", type: "suit"},
		{source: "Microsoft", target: "Motorola", type: "suit"},
		{source: "Motorola", target: "Microsoft", type: "suit"},
		{source: "Huawei", target: "ZTE", type: "suit"},
		{source: "Ericsson", target: "ZTE", type: "suit"},
		{source: "Kodak", target: "Samsung", type: "resolved"},
		{source: "Apple", target: "Samsung", type: "suit"},
		{source: "Kodak", target: "RIM", type: "suit"},
		{source: "Nokia", target: "Qualcomm", type: "suit"}
		];

		var nodes = {};

		// Compute the distinct nodes from the links.
		links.forEach(function(link) {
			link.source = nodes[link.source] || (nodes[link.source] = {name: link.source});
			link.target = nodes[link.target] || (nodes[link.target] = {name: link.target});
		});

		var width = screen.width;
		var height = 600;

		var force = d3.layout.force()
			.nodes(d3.values(nodes))
			.links(links)
			.size([width, height])
			.linkDistance(110)
			.charge(-300)
			.on("tick", tick)
			.start();

		var svg = d3.select("body").append("svg")
			.attr("width", width)
			.attr("height", height);

		// Per-type markers, as they don't inherit styles.
		svg.append("defs").selectAll("marker")
			.data(["suit", "licensing", "resolved"])
			.enter().append("marker")
			.attr("id", function(d) { return d; })
			.attr("viewBox", "0 -5 10 10")
			.attr("refX", 15)
			.attr("refY", -1.5)
			.attr("markerWidth", 6)
			.attr("markerHeight", 6)
			.attr("orient", "auto")
			.append("path")
			.attr("d", "M0,-5L10,0L0,5");

		var path = svg.append("g").selectAll("path")
			.data(force.links())
			.enter().append("path")
			.attr("class", function(d) { return "link " + d.type; })
			.attr("marker-end", function(d) { return "url(#" + d.type + ")"; });

		var circle = svg.append("g").selectAll("circle")
			.data(force.nodes())
			.enter().append("circle")
			.attr("r", 9)
			.call(force.drag);

		var text = svg.append("g").selectAll("text")
			.data(force.nodes())
			.enter().append("text")
			.attr("x", 8)
			.attr("y", ".31em")
			.style("font-size","15px")
			.text(function(d) { return d.name; });

		// Use elliptical arc path segments to doubly-encode directionality.
		function tick() {
			path.attr("d", linkArc);
			circle.attr("transform", transform);
			text.attr("transform", transform);
		}

		function linkArc(d) {
			var dx = d.target.x - d.source.x,
			dy = d.target.y - d.source.y,
			dr = Math.sqrt(dx * dx + dy * dy);
			return "M" + d.source.x + "," + d.source.y + "A" + dr + "," + dr + " 0 0,1 " + d.target.x + "," + d.target.y;
		}

		function transform(d) {
			return "translate(" + d.x + "," + d.y + ")";
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