require 'cgi'
class AuthenticationController < ApplicationController
  # $botauthUrl = "https://api.twitch.tv/kraken/oauth2/authorize?client_id=#{$clientID}&redirect_uri=#{CGI.escape($redirectUri)}&response_type=token&scope=chat_login"
  # $channelauthUrl = "https://api.twitch.tv/kraken/oauth2/authorize?client_id=#{$clientID}&redirect_uri=#{CGI.escape($redirectUri)}&response_type=token&scope=chat_login+channel_read+user_read+channel_editor"
  @test = ""
  def index
  end

  #TODO: Streamline user data entry into a single form with persistent data,
  #and two separate forms for Oauth generationgs
  def saveUserInfo
    redirect_to :back
    #check if the user exists in the database
    if !BotUser.exists?(channeluser: params[:userName])
      #create new BotUser entry in DB
      @user = BotUser.new
      @user.channeluser = params[:userName]
      @user.channelname = params[:userName]
      @user.clientid = params[:clientID]
      @user.clientsecret = params[:clientSecret]
      @user.botname = params[:botName]
      @user.redirecturi = CGI.escape(params[:redirectUri])
      if @user.save
        $userName = @user.channeluser
        $clientID = @user.clientid
        $clientsecret = @user.clientsecret
        $botName = @user.botname
        $redirectUri = @user.redirecturi
        $botOauth = @user.botoauth
        $userOauth = @user.useroauth
      end
    else
      #Find the user and update field to DB data
      @user = BotUser.find_by(channeluser: params[:userName])
      @user.channeluser = params[:userName]
      @user.channelname = params[:userName]
      if params[:clientID] != ''
        @user.clientid = params[:clientID]
      end
      if params[:clientSecret] != ''
        @user.clientsecret = params[:clientSecret]
      end
      if params[:botName] != ''
        @user.botname = params[:botName]
      end
      if params[:redirectUri] != ''
        @user.redirecturi = CGI.escape(params[:redirectUri])
      end
      if @user.save
        $userName = @user.channeluser
        $clientID = @user.clientid
        $clientsecret = @user.clientsecret
        $botName = @user.botname
        $redirectUri = CGI.unescape(@user.redirecturi)
        $botOauth = @user.botoauth
        $userOauth = @user.useroauth
      end
      $botauthUrl = "https://api.twitch.tv/kraken/oauth2/authorize?client_id=#{$clientID}&redirect_uri=#{CGI.escape($redirectUri)}&response_type=token&scope=chat_login"
      $channelauthUrl = "https://api.twitch.tv/kraken/oauth2/authorize?client_id=#{$clientID}&redirect_uri=#{CGI.escape($redirectUri)}&response_type=token&scope=chat_login+channel_read+user_read+channel_editor"
    end
  end

  def getUserOauth
    redirect_to $channelauthUrl
  end

  def saveUserOauth
    render :nothing => true
    @user = BotUser.find_by(channeluser: $userName)
    @user.useroauth = params[:id]
    $userOauth = params[:id]
  end

  def getBotOauth
    redirect_to $botauthUrl
  end

  def saveBotOauth
    render :nothing => true
    @user = BotUser.find_by(channeluser: $userName)
    @user.botoauth = params[:id]
    $botOauth = params[:id]
  end

end
