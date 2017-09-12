function getFollows(){
  $.ajax({
    type: 'GET',
    url: '/points/fillFollowers',
    success: function(data){
    },
    error: function(xhr, status, error){
      //add more error handling
      alert("An error has occured");
    }
  });
}
