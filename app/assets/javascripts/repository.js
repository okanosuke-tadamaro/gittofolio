//DRAW GRAPHS ON TOP PANEL
function drawLineChart() {
	var lineArea = $('#line-chart').get(0).getContext('2d');
	var chartData = $('.chart-data').data();
	var lineChartData = chartData.lineChart;
	var lineChart = {
		labels: lineChartData[0],
		datasets: [{
			fillColor: "rgba(151,187,205,0.5)",
			strokeColor: "rgba(151,187,205,1)",
			pointColor: "rgba(151,187,205,1)",
			pointStrokeColor: "#fff",
			data: lineChartData[1]
		}]
	};
	new Chart(lineArea).Line(lineChart, {scaleFontSize: 10, scaleFontFamily: "'Roboto Condensed'"});
}

function drawBarChart() {
	var barArea = $('#bar-chart').get(0).getContext('2d');
	var barChartData = $('.chart-data').data().barChart;
	var barChart = {
		labels: barChartData[0],
		datasets: [{
			fillColor : "rgba(151,187,205,0.5)",
			strokeColor : "rgba(151,187,205,1)",
			data: barChartData[1]
		}]
	};
	new Chart(barArea).Bar(barChart, {scaleFontSize: 10, scaleFontFamily: "'Roboto Condensed'"});
}

//DRAW RADAR CHART ON DETAIL VIEW
function drawRadarChart(radarData) {
	var radarArea = $('#radar-chart').get(0).getContext('2d');
	var radarChart = {
		labels: radarData.language_labels,
		datasets: [{
			fillColor: "rgba(151,187,205,0.5)",
			strokeColor: "rgba(151,187,205,1)",
			pointColor: "rgba(151,187,205,1)",
			pointStrokeColor : "#fff",
			data : radarData.language_values
		}]
	};
	new Chart(radarArea).Radar(radarChart, {scaleOverlay: false});
}

//AJAX REQUEST TO GET SINGLE REPO INFO
function getSingleRepo() {
	var userName = window.location.pathname.split('/')[1];
	$.ajax({
		url: '/detail',
		method: 'get',
		dataType: 'json',
		data: {username: userName, repo_name: $(this).find('h3').text()}
	}).done(function(data) {
		var radarArea = $('<canvas>').attr('id', 'radar-chart').attr('height', '522');
		$('.repo-list-container').toggle('slide', 500);
		$('.content-panel').append(radarArea);
		drawRadarChart(data.radar_data);
	});
}

$(document).ready(function() {

	var currentPage = $('#page');
	if (currentPage.data('controller') === 'repositories' && currentPage.data('action') === 'index') {
		drawLineChart();
		drawBarChart();

		$('.item div').hover(function() {
			$(this).animate({'transform': 'rotate(15deg)'}, 200);
		}, function() {
			$(this).animate({'transform': 'rotate(0deg)'}, 100);
		});
	}

});
