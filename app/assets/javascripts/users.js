function toggleCheckBox(e) {
	var repoId = $(e.target).attr('for');
	var box = $('#' + repoId);
	if (!box.prop('checked')) {
		// box.prop('checked', true);
		updateDisplayStatus(repoId, true);
	} else {
		// box.prop('checked', false);
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
		debugger;
	});
}

$(document).ready(function() {

	var currentPage = $('#page');
	if (currentPage.data('controller') === 'users') {

		$('.switch').on('click', 'label', toggleCheckBox);
	
	}

});