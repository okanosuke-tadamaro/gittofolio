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

$(document).ready(function() {
	drawLineChart();
	drawBarChart();
});