$(document).on('turbolinks:load', function () {
	var $block = $('#public_bets')
	$('.page_1').addClass('selected')

	$('.pagination').each(function () {
		$(this).on('ajax:success', function(e, data) {
			var bets = data.bet_list;
			var page = data.page;
			$.get({url: "bets/partial_bet_show", data: {bets: bets} }, function(rendered) {
				$block.html(rendered);
				$('.pagination').removeClass('selected');
				$('.page_'+page).addClass('selected');
			});
		}).on('ajax:error', function(e, data) {
			console.log(data)
			console.log('failure')
		})
	})
})
