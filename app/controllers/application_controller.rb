class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  $botStatus = false
  protect_from_forgery with: :exception
  helper :all

  #Collect User Data from DB if it exists
  if BotUser.exists?(1)
    @userInfo = BotUser.find(1)
    $userName = @userInfo.channeluser
    $clientID = @userInfo.clientid
    $clientsecret = @userInfo.clientsecret
    $botName = @userInfo.botname
    $redirectUri = @userInfo.redirecturi
    $botOauth = @userInfo.botoauth
    $userOauth = @userInfo.useroauth
  end

end
