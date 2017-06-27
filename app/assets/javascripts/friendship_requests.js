$(document).on('turbolinks:load', function () {
  
  var $users;
  console.log($users);
  if (($users = $('#f_request')).length) {
    console.log('data2');
    // procesamiento de la respuesta del request Ajax para seguir/deseguir un usuario
    $users.on('ajax:success', function (e, data) {
      var $button;
      console.log('data3');

      // si la respuesta contiene un usuario al que se sigue
      if (data.friendship) {
        console.log('data4');
        $button = $('.user-stream-item [data-user-id="' + data.friendship.id + '"]');
        $button.data('method', 'delete');
        $button.attr('href', '/friendship_requests/' + data.friend.id);
        $button.text('Cancel friend request');
      } else {
        console.log('data5');
        $button = $('.user-stream-item [data-user-id="' + data.unrequest.id + '"]');
        $button.data('method', 'post');
        $button.attr('href', '/users/' + data.unrequest.id + '/friendship_requests');
        $button.text('Send friend request');
      }
    }).on('ajax:error', function (e, data) {
      console.log(data);
    });
  }
  else{
    console.log('data10');
  }
});