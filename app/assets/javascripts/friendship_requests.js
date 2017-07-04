$(document).on('turbolinks:load', function () {
  
  var $buttons = $('.f_request');
  $notice = $('#notice');
  // procesamiento de la respuesta del request Ajax para seguir/deseguir un usuario
  $buttons.each(function() {
    $(this).on('ajax:success', function (e, data) {
    $notice.css('display', 'block');
    $notice.text(data.message);
    if (data.request) {
      console.log('created');
      $(this).data('method', 'delete');
      $(this).attr('href', '/friendship_requests/' + data.request.id);
      $(this).text('Cancel friend request');
      $(this).addClass('delete').removeClass('round_$(this)');

      var $received_requests = $('#received_requests');
      if ($received_requests) {
        console.log('found received')
        $received_requests.append("<p class='request'>" + data.request.name + "</p>")
        var $requests = $received_requests.find('.request');
        var $sorted_requests = $requests.sort(function(a,b) {
          return $(a).text() > $(b).text();
        });
        $received_requests.html($sorted_requests);
      }
    } else if (data.friendship) {
      $(this).remove();
      var $friend_list = $('#friend_list');
      $friend_list.append("<p class='friend'><a href='/users/" + data.friendship.id + "'>" + data.friendship.name + "</a></p>");
      var $friends = $('.friend');
      var $sorted_friends = $friends.sort(function(a,b) {
        return $(a).find('a').text() > $(b).find('a').text();
      });
      $friend_list.html($sorted_friends);
      console.log($sorted_friends);
    } else {
      $parent = $(this).parent()
      console.log('deleted')
      $(this).data('method', 'post');
      $(this).attr('href', '/users/' + data.unrequest.id + '/friendship_requests');
      $(this).text('Send friend request');
      $(this).removeClass('delete').addClass('round_$(this)');
      var $received_requests = $('#received_requests');
      if ($parent.attr('class') == 'request') {
        $parent.remove();
      } else if ($received_requests) {
        $received_requests.find('p.request').filter( function() {
          return $(this).text().trim() === data.unrequest.name.trim()
        } ).remove();
      }
    }
    }).on('ajax:error', function (e, data) {
      console.log(data);
    })
  });
});