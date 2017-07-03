window.onload = function(){

    var lochash = document.location.hash.substr(1);
    var token = lochash.substr(lochash.indexOf('access_token='))
                  .split('&')[0]
                  .split('=')[1];
    var scope = lochash.substr(lochash.indexOf('scope=')).split('&')[0].split('=')[1];
    if(scope.length > 10){
      if(typeof token != 'undefined'){
        $.ajax({
          type: 'POST',
          url: '/authentication/' + token + '/saveUserOauth',
          success: function(){
          }
        });
      }
    }
    else{
      if(typeof token != 'undefined'){
        $.ajax({
          type: 'POST',
          url: '/authentication/' + token + '/saveBotOauth',
          success: function(){
          }
        });
      }
    }

  };
