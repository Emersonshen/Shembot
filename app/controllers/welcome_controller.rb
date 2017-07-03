require 'uri'
require 'net/http'
require 'hello'
require 'cinch'

class WelcomeController < ApplicationController
  def index

  end

  def startBot
    #render :nothing => true
    if $botOauth != ''
      $bot = Cinch::Bot.new do
        configure do |c|
          c.user = "Shembot4"
          c.nick = ["Shembot4"]
          c.server = "irc.chat.twitch.tv"
          c.channels = ["#shemerson"]
          c.password = "oauth:#{$botOauth}"
          c.plugins.plugins = [Hello]
        end
      end
      $botThread = Thread.new do
        $bot.start
      end
      respond_to do |format|
        format.json { render :json => true }
      end
      $botStatus = true
    else
      respond_to do |format|
        format.json { render :json => false }
      end
    end
  end
  def stopBot
    #render :nothing => true
    if $botThread != nil
      respond_to do |format|
        format.json { render :json => true }
      end
      $botStatus = false
    else
      respond_to do |format|
        format.json { render :json => false }
      end
    end
    $bot.quit
    $botThread.kill
  end
end
