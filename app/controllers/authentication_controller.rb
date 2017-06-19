class AuthenticationController < ApplicationController

  def index
  end

  #TODO: Streamline user data entry into a single form with persistent data,
  #and two separate forms for Oauth generation
  def saveUserName
    redirect_to :back
    #check if the user exists in the database
    if !BotUser.exists?(channeluser: params[:userName])
      #create new BotUser entry in DB
      @user = BotUser.create(channeluser: params[:userName], clientid: params[:clientID])
      $userName = @user.channeluser
      $clientID = ''
      $clientsecret = ''
      $botName = ''
    else
      #Find the user and update field to DB data
      @user = BotUser.find_by(channeluser: params[:userName])
      $userName = @user.channeluser
      $clientID = @user.clientid
      $clientsecret = @user.clientsecret
      $botName = @user.botname
    end
  end

  def saveClientId
    redirect_to :back
    #Find the entry in DB by the Username
    #Assumption: the user has already entered their username
    #TODO: Add checking in case username has not been entered

    @user = BotUser.find_by(channeluser: $userName)
    @user.clientid = params[:clientID]
    if @user.save
      $clientID = @user.clientid
    end
  end

  def saveClientSecret
    #TODO: Finish this function, grab entry from DB and update if new information is added
    redirect_to :back
    $clientSecret = params[:clientSecret]
  end

  def saveUserOauth

  end

  def saveBotOauth
    redirect_to :back
    #TODO: update Bot name in DB and send the user to the Twitch authorize page
    #to get Oauth2 token, change where the app redirectURI
    #update fields once the user has been returned to the page
    #don't save Oauth to DB
    @user = BotUser.find_by(channeluser: $userName)
    @user.botname = params[:botName]
    if @user.save
      $botName = @user.botname
    end
    $botName = params[:botName]
    $botOauth = params[:botOauth]
  end

end
