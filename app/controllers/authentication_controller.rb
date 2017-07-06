require 'cgi'
class AuthenticationController < ApplicationController

  def index
  end

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
    #save the Oauth for Accessing User Information to the database
    render :nothing => true
    @user = BotUser.find_by(channeluser: $userName)
    @user.useroauth = params[:id]
    if @user.save
      $userOauth = params[:id]
    end
  end

  def getBotOauth
    redirect_to $botauthUrl
  end

  def saveBotOauth
    #save the Oauth for Bot to access the Chat
    render :nothing => true
    @user = BotUser.find_by(channeluser: $userName)
    @user.botoauth = params[:id]
    if @user.save
      $botOauth = params[:id]
    end
  end

end
