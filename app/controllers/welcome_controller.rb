require 'uri'
require 'net/http'
require 'hello'
require 'cinch'

class WelcomeController < ApplicationController
  def index

  end
  
  def startBot
    @botThread = Thread.new do
      bot = Cinch::Bot.new do
        configure do |c|
          c.user = "shembot4"
          c.nick = ["shembot4"]
          c.server = "irc.chat.twitch.tv"
          c.channels = ["#shemerson"]
          c.password = "oauth:#{$oAuthToken}"
          c.plugins.plugins = [Hello]
        end
      end
      bot.start
    end
    if @botThread != NULL
      return true
    else
      return false
    end
  end
  def stopBot
    @botThread.kill
    if @botThread != NULL
      return true
    else
      return false
    end
  end
end
