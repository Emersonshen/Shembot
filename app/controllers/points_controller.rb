require 'net/http'
require 'uri'
require 'json'
class PointsController < ApplicationController

  def index
    @followers = Follower.search(params[:page])
    puts @followers
  end

  def fillFollowers
    render :nothing => true
    @getfollowsUrl = URI.parse("https://api.twitch.tv/kraken/channels/shemerson/follows?limit=100")
    @res = Net::HTTP.start(@getfollowsUrl.host, @getfollowsUrl.port,
                            :use_ssl => @getfollowsUrl.scheme == 'https') do |http|
      req = Net::HTTP::Get.new @getfollowsUrl
      req['Client-ID'] = $clientID
      req['Authorization'] = "OAuth #{$userOauth}"
      http.request req
    end
    response = JSON.parse @res.body
    follows = response['follows']
    follows.each do |f|
      if !Follower.exists?(name: f['user']['display_name'])
        follower = Follower.new
        follower.name = f['user']['display_name']
        follower.points = 0
        follower.save
      end
    end
  end
end
