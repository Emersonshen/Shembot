require 'net/http'
require 'uri'
require 'json'
class PointsController < ApplicationController

  def index
    @followers = Follower.search(params[:page])
    if(PointConfig.exists?(1))
      config = PointConfig.find(1)
      @name = config.name
      @points = config.points
      @period = config.period
    end
  end

  def savePointsConfig
    redirect_to :back
    if !PointConfig.exists?(name: params[:name])
      @config = PointConfig.new
      @config.name = params[:name]
      @config.period = params[:period]
      @config.points = params[:points]
    else
      @config = PointConfig.find(1)
      if params[:name] != ''
        @config.name = params[:name]
      end
      if params[:period] != ''
        @config.period = params[:period]
      end
      if params[:points] != ''
        @config.points = params[:points]
      end
    end
    if @config.save
      @name = @config.name
      @points = @config.points
      @period = @config.period
    end
  end

  def fillFollowers
    render :nothing => true
    offset = 0
    puts $userName
    loop do
      @uri = URI.parse("https://api.twitch.tv/kraken/channels/#{$userName.downcase}/follows?limit=100&offset=#{offset}")
      @res = Net::HTTP.start(@uri.host, @uri.port,
                              :use_ssl => @uri.scheme == 'https') do |http|
        req = Net::HTTP::Get.new @uri
        req['Client-ID'] = $clientID
        req['Authorization'] = "OAuth #{$userOauth}"
        http.request req
      end
      response = JSON.parse @res.body
      follows = response['follows']
      clear = false
      if !follows.any?
        clear = true
        break
      end
      follows.each do |f|
        if !Follower.exists?(name: f['user']['display_name'])
          follower = Follower.new
          follower.name = f['user']['display_name']
          follower.points = 100
          follower.save
        else
          clear = true
          break
        end
      end
      break if clear
      offset += 100
    end
  end
end
