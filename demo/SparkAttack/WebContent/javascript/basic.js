var stopPolling = true;

var pollRequest;
var submitTxt="<b style=\"font-size: 2em;\">Go</b><span class=\"glyphicon glyphicon-flash\" style=\"font-size: 2em;\"></span>"
var stopTxt="<span class=\"glyphicon glyphicon-remove\" style=\"font-size: 2em;\"></span>"


$(document).ready(function(){
	$('#submit_btn').html(submitTxt);
	$('#submit_btn').blur();
	$('#sparkSearch').submit(function(){
		if ($('#submit_btn').html() == submitTxt) {
			$('body').focus();
			$.ajax({
				url: 'WordCloud',
				type: 'POST',
				dataType:'text',
				data: {
					searchTerms:$("#searchTerms").val(),
					sparkSource:$("#sparkSource option:selected").text()
				},
				success: function(data){
					stopPolling = false;
					$('#submit_btn').html(stopTxt);
					$("#searchTerms").prop('disabled', true);
					$("#sparkSource").prop('disabled', true);
					loader({width: screen.width, height: 500, container: "#svgg", id: "loader"})();
					poll();
				}
			});
		}
		else {
			clearSearch();
		}
		return false;
	});
	$("#sparkSource").change(function(){
		if ($("#sparkSource option:selected").text() == "Voice") {
			$('#searchTerms').val('');
			$("#searchTerms").prop('disabled', true);
		}
		else {
			$("#searchTerms").prop('disabled', false);
		}
	});
});


function poll() {
	pollRequest = $.ajax({
		url: "WordCloud",
		type: 'POST',
		dataType:'text',
		success: function(data) {
			if (!stopPolling) {
				setTimeout(function() {	if(stopPolling){return;}else{updateData(data); poll()}}, 5000);
			}
		}
	})
};




	$( document.body ).on( 'click', '.dropdown-menu li', function( event ) {
	 
	   var $target = $( event.currentTarget );
	 
	   $target.closest( '.btn-group' )
	      .find( '[data-bind="label"]' ).text( $target.text() )
	         .end()
	      .children( '.dropdown-toggle' ).dropdown( 'toggle' );
	 
	   return false;
	 
	});


function clearSearch(){
	pollRequest.abort();
	$('#submit_icon').removeClass("glyphicon glyphicon-remove").addClass("glyphicon glyphicon-search");
	$('#submit_btn').html(submitTxt);
	$("#searchTerms").prop('disabled', false);
	$("#sparkSource").prop('disabled', false);
	
	$('#searchTerms').val('');
	stopPolling = true;
	
	
	d3.select("#svgg").html("")
	.append("svg")
	.attr("width", screen.width)
	.attr("height", 500);
	
	
	$.ajax({
		url: 'WordCloud',
		type: 'POST',
		dataType:'text',
		data: {
			stopSpark: "true"
		},
		success: function(data){
			console.log("Stop message has sent")
		}
	});
}



function updateData(data){	
	var myjson = data;
	
	if(myjson.length <= 31){
		return;
	}
	
	
	root = JSON.parse( myjson );

	d3.select("div#svgg").html("");
	
	var container = d3.select("div#svgg");
	
	var width = screen.width;
	var height = 500;
	
	var diameter = 550;
	var format = d3.format(",d");
	var color = d3.scale.ordinal()
		.domain(["g","b","n"])
		.range(["#8ED081", "#D17F50", "#DCE2AA"]);

	var bubble = d3.layout.pack()
		.sort(null)
		.size([diameter, diameter])
		.padding(1.5);

	var svg = d3.select("div#svgg").append("svg")
		.attr("preserveAspectRatio", "xMinYMin meet")
		.attr("viewBox", "0 0 " + width + " " + height)
		.classed("svg-content-responsive", true)
		.attr("class", "bubble");
	
	var node = svg.selectAll(".node")
		.data(bubble.nodes(classes(root))
		.filter(function(d) { return !d.children; }))
		.enter().append("g")
		.attr("class", "node")
		.attr("transform", function(d) { return "translate(" + (d.x + width/2 - diameter/2) + "," + (d.y + 2) + ")"; });

		node.append("title")
			.text(function(d) { return d.className + ": " + format(d.value); });

		node.append("circle")
			.attr("r", function(d) { return d.r; })
			.style("fill", function(d) {return color(d.type);});

		node.append("text")
			.attr("dy", ".3em")
			.style("font-family","sans-serif")
			.style("text-anchor", "middle")
			.text(function(d) { return d.className.substring(0, d.r / 3); });
		
	function classes(root) {
		var classes = [];

		function recurse(name, node) {
			if (node.children) node.children.forEach(function(child) { recurse(node.name, child); });
			else classes.push({packageName: name, className: node.name, value: node.size, type: node.type});
		}

		recurse(null, root);
		return {children: classes};
	}
};


function loader(config) {
	return function() {
		d3.select("#svgg").html("");
		
		var radius = Math.min(config.width, config.height) / 2;
		var tau = 2 * Math.PI;

		var arc = d3.svg.arc()
			.innerRadius(radius*0.3)
			.outerRadius(radius*0.4)
			.startAngle(0);
		
		d3.select("div#svgg")
			.style("padding-bottom", "0%");

		var svg = d3.select(config.container).append("svg")
			.attr("id", config.id)
			.attr("width", config.width)
			.attr("height", config.height)
			.append("g")
			.attr("transform", "translate(" + config.width / 2 + "," + config.height / 2 + ")")

		var background = svg.append("path")
			.datum({endAngle: 0.33*tau})
			.style("fill", "#7AB3BF")
			.attr("d", arc)
			.call(spin, 1500)

			var loadlabel = svg.append("text")
				.style("font-family","sans-serif")
				.style("font-size", "30px")
				.style("text-anchor", "middle")
				.style("fill", "#4C7C8C")
				.text("loading")
			
			
			function spin(selection, duration) {
				selection.transition()
				.ease("linear")
				.duration(duration)
				.attrTween("transform", function() {
				return d3.interpolateString("rotate(0)", "rotate(360)");
			});

			setTimeout(function() { spin(selection, duration); }, duration);
		}

		function transitionFunction(path) {
			path.transition()
			.duration(7500)
			.attrTween("stroke-dasharray", tweenDash)
			.each("end", function() { d3.select(this).call(transition); });
		}
	};
}


