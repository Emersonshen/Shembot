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
          c.user = "#{$botName}"
          c.nick = ["#{$botName}"]
          c.server = "irc.chat.twitch.tv"
          c.channels = ["##{$userName}"]
          c.password = "oauth:#{$botOauth}"
          c.plugins.plugins = [Hello]
        end
      end
      $botThread = Thread.new do
        $bot.start
      end
      $pointsThread = Thread.new do
        @stoppoints = true
        @config = PointConfig.find(1)
        while @stoppoints
          @getchattersUrl = URI.parse("https://tmi.twitch.tv/group/user/#{$userName.downcase}/chatters")
          @res = Net::HTTP.start(@getchattersUrl.host, @getchattersUrl.port,
                                  :use_ssl => @getchattersUrl.scheme == 'https') do |http|
            req = Net::HTTP::Get.new @getchattersUrl
            http.request req
          end
          response = JSON.parse @res.body
          chatters = response['chatters']

          chatters['moderators'].each do |v|
            chatter = Follower.find_by(name: v)
            chatter.points += @config.points
          end
          chatters['staff'].each do |v|
            chatter = Follower.find_by(name: v)
            chatter.points += @config.points
          end
          chatters['admins'].each do |v|
            chatter = Follower.find_by(name: v)
            chatter.points += @config.points
          end
          chatters['global_mods'].each do |v|
            chatter = Follower.find_by(name: v)
            chatter.points += @config.points
          end
          chatters['viewers'].each do |v|
            chatter = Follower.find_by(name: v)
            chatter.points += @config.points
          end
          puts "Testing Period"
          sleep @config.period.minutes
        end
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
