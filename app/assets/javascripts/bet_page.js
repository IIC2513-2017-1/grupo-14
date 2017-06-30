$(document).on('turbolinks:load', function () {
	var $block = $('#public_bets')
	$('.page_1').addClass('selected')

	$('.pagination').each(function () {
		$(this).on('ajax:success', function(e, data) {
			$('.pagination').removeClass('selected');
			var bets = data.bet_list;
			var page = data.page;
			$('.page_'+page).addClass('selected');
			$.get({url: "bets/partial_bet_show", data: {bets: bets} }, function(rendered) {
				$block.html(rendered);
			});
		}).on('ajax:error', function(e, data) {
			console.log(data)
			console.log('failure')
		})
	})
})
