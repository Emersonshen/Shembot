require 'uri'
require 'net/http'
require 'plugins'
require 'cinch'
require 'tracker'

class WelcomeController < ApplicationController

  def index
  end

  def startBot
    #render :nothing => true
    if $botOauth != ''
      $bot = Cinch::Bot.new do
        configure do |c|
          c.user = "#{$botName}"
          c.nick = ["#{$botName}"]
          c.server = "irc.chat.twitch.tv"
          c.channels = ["##{$userName.downcase}"]
          c.password = "oauth:#{$botOauth}"
          c.plugins.plugins = [Hello, Commands]
        end
      end
      $botThread = Thread.new do
        $bot.start
      end
      $botStatus = true
      respond_to do |format|
        format.json { render :json => true }
      end
    else
      respond_to do |format|
        format.json { render :json => false }
      end
    end
    # $tracker = Tracker.new :user => $userName, :type => "point", :clientid => $clientID, :userOauth => $userOath
    # $trackerThread = Thread.new do
    #   $tracker.start
    # end
  end

  def stopBot
    #render :nothing => true
    $botStatus = false
    # $tracker.quit
    # $trackerThread.kill
    $bot.quit
    $botThread.kill
  end
end
