$(document).on('turbolinks:load', function () {
	$notice = $('#notice');
	$('.unfriend').each(function() {
		$(this).on('ajax:success', function (e, data) {
			console.log(data)
			$notice.text(data.notice);
			$notice.css('display', 'block');
			$(this).parent().remove();
		}).on('ajax:error', function (e, data) {
      console.log(data);
    	})
	})
})