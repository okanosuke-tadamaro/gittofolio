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

function toggleCheckBox() {
	var repoId = $(e.target).attr('for');
	var box = $('#' + repoId);
	if (!box.prop('checked')) {
		updateDisplayStatus(repoId, true);
	} else {
		updateDisplayStatus(repoId, false);
	}
}

function updateDisplayStatus(id, status) {
	$.ajax({
		url: '/update_display/' + id,
		method: 'get',
		dataType: 'json',
		data: { display: status }
	}).done(function(data) {
		
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

	if (currentPage.data('controller') === 'repositories' && currentPage.data('action') === 'show') {
		$('.switch').on('click', 'label', toggleCheckBox);
	}

});
