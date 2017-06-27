$(document).on('turbolinks:load', function () {
  
  var $button;
  $button = $('#f_request');
  $notice = $('#notice');
  $notice.css('display', 'none');
  // procesamiento de la respuesta del request Ajax para seguir/deseguir un usuario
  $button.on('ajax:success', function (e, data) {
    console.log(data);
    $notice.css('display', 'block');
    $notice.text(data.message);
    if (data.request) {
      console.log('created');
      $button.data('method', 'delete');
      $button.attr('href', '/friendship_requests/' + data.request.id);
      $button.text('Cancel friend request');
      $button.addClass('delete').removeClass('round_button');

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
      $button.remove();
      var $friend_list = $('#friend_list');
      $friend_list.append("<p class='friend'><a href='/users/" + data.friendship.id + "'>" + data.friendship.name + "</a></p>");
      var $friends = $('.friend');
      var $sorted_friends = $friends.sort(function(a,b) {
        return $(a).find('a').text() > $(b).find('a').text();
      });
      $friend_list.html($sorted_friends);
      console.log($sorted_friends);
    } else {
      $parent = $button.parent()
      console.log('deleted')
      $button.data('method', 'post');
      $button.attr('href', '/users/' + data.unrequest.id + '/friendship_requests');
      $button.text('Send friend request');
      $button.removeClass('delete').addClass('round_button');
      var $received_requests = $('#received_requests');
      if ($received_requests) {
        console.log('found pending')
        $received_requests.find('p.request').filter( function() {
          return $(this).text().trim() === data.unrequest.name.trim()
        } ).remove();
      }
      if ($parent.attr('class') == 'request') {
        $parent.remove();
      }
    }
  }).on('ajax:error', function (e, data) {
    console.log(data);
  });
});