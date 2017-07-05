function getFollows(){
  $.ajax({
    type: 'GET',
    url: '/points/fillFollowers',
    success: function(data){
      //add warning saying the bot hasn't been started yet
    },
    error: function(xhr, status, error){
      //add more error handling
      alert("An error has occured");
    }
  });
}
