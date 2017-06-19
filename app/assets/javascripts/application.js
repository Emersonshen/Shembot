// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require turbolinks
//= require materialize-sprockets
//= require welcome


window.onload(function(){
  Twitch.init({clientId : $('#clientId').text()},function(error, status){
      if(status.authenticated){
        $.ajax({
          type: 'POST',
          url: '/welcome/' + Twitch.getToken() + '/saveOauth',
          success: function(){
          }
        });
        $('#testToken').text(Twitch.getToken());
      }
    });
});
function twitchLogin(){
  Twitch.login({
      scope: ['chat_login', 'user_read', 'channel_read']
    });
}
function startBot(){
  if(status.authenticated){
    $.ajax({
      type: 'GET',
      url: '/welcome/startBot',
      success: function(data){
        if(data){
          $('#startBot').css('display', 'none');
          $('#stopBot').css('display', 'block');
        }
        //add warning saying the bot hasn't been started yet
      },
      error: function(xhr, status, error){
        //add more error handling
        alert("An error has occured: \n Make Sure you are logged in.");
      }
    });
  }
  else{
    alert("Please Login First");
  }
}
function stopBot(){
  if(status.authenticated){
    $.ajax({
      type: 'GET',
      url: '/welcome/stopBot',
      success: function(data){
        if(data){
          $('#startBot').css('display', 'block');
          $('#stopBot').css('display', 'none');
        }
        //add warning saying the bot hasn't been started yet
      },
      error: function(xhr, status, error){
        //add more error handling
        alert("An error has occured: \n Make Sure you are logged in.");
      }
    });
  }

}
/*function twitchLogout(){
  Twitch.logout(function(error){});
  location.reload();
}*/
