class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  $oAuth = ''
  $clientID = ''
  $clientSecret = ''
  $userName = ''
  $userOauth = ''
  $botOauth = ''
  $botName = ''
  protect_from_forgery with: :exception
  helper :all
end
