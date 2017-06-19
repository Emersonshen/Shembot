/*window.onload = function(){
  Twitch.init({clientId : '3osendswsjokgwkrmn6vejyqou7w0k'},function(error, status){
      if(status.authenticated){
        $('#twitchLogin').css('display', 'none');
        $('#twitchLogout').css('display', 'block');
        $.ajax({
          type: 'POST',
          url: '/welcome/' + Twitch.getToken() + '/saveOauth',
          success: function(){
          }
        });
        $('#testToken').text(Twitch.getToken());
      }
      if(!status.authenticated){
        $('#twitchLogin').css('display', 'block');
        $('#twitchLogout').css('display', 'none');
      }
    });
}

function twitchLogin(){
  Twitch.login({
      scope: ['chat_login', 'user_read', 'channel_read']
    });
}*/
/*function twitchLogout(){
  Twitch.logout(function(error){});
  location.reload();
}*/
