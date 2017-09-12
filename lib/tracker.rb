class Tracker
  attr_accessor :user, :type, :clientid, :userOauth
  def initialize params = {}
    puts "Initializing Tracker"
    @stop = true
    @config = PointConfig.find(1)
    @user = params.fetch :user
    @clientid = params.fetch :clientid
    @userOauth = params.fetch :userOauth
    @type = params.fetch :type
    puts "Type: #{@type}"
    if @type == "point"
      @uri = URI.parse("https://tmi.twitch.tv/group/user/#{@user.downcase}/chatters")
    end
  end

  def pointTracker
    # while @stop
      puts "Starting Point Tracker"
      puts "Period Time: #{@config.period}"
      puts "Point Amount: #{@config.period}"
      puts @user
      puts @uri
      # sleep @config.period.minutes
      puts "Starting Increase"
      @res = Net::HTTP.start(@uri.host, @uri.port,
                              :use_ssl => @uri.scheme == 'https') do |http|
        req = Net::HTTP::Get.new @uri
        http.request req
      end
      response = JSON.parse @res.body
      chatters = response['chatters']
      puts "Mods"
      chatters['moderators'].each do |v|
        if Follower.exists?(["lower(name) = ?", v.downcase])
          chatter = Follower.where('lower(name) = ?', v.downcase)
          puts "found"
          puts @config.points
          points = chatter.points + @config.points
          chatter.points = points
          puts "increased"
          chatter.save
          puts "saved"
        end
      end
      puts "Staff"
      chatters['staff'].each do |v|
        if Follower.exists?(["lower(name) = ?", v.downcase])
          chatter = Follower.where('lower(name) = ?', v.downcase)
          chatter.points += @config.points
          chatter.save
        end
      end
      puts "admins"
      chatters['admins'].each do |v|
        if Follower.exists?(["lower(name) = ?", v.downcase])
          chatter = Follower.where('lower(name) = ?', v.downcase)
          chatter.points += @config.points
          chatter.save
        end
      end
      puts "Global Mods"
      chatters['global_mods'].each do |v|
        if Follower.exists?(["lower(name) = ?", v.downcase])
          chatter = Follower.where('lower(name) = ?', v.downcase)
          chatter.points += @config.points
          chatter.save
        end
      end
      puts "Viewers"
      chatters['viewers'].each do |v|
        if Follower.exists?(["lower(name) = ?", v.downcase])
          #puts "Not Working"
          chatter = Follower.where('lower(name) = ?', v.downcase)
          chatter.points += @config.points
          chatter.save
        end
      end
      puts "Points Increased"
    # end
  end

  def followTracker
    offset = 0
    loop do
      @uri = URI.parse("https://api.twitch.tv/kraken/channels/#{@user.downcase}/follows?limit=25&offset=#{offset}")
      @res = Net::HTTP.start(@uri.host, @uri.port,
                              :use_ssl => @uri.scheme == 'https') do |http|
        req = Net::HTTP::Get.new @uri
        req['Client-ID'] = @clientID
        req['Authorization'] = "OAuth #{@userOauth}"
        http.request req
      end
      response = JSON.parse @res.body
      follows = response['follows']
      clear = false
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
      @offset += 25
    end
    while @stop
      @uri = URI.parse("https://api.twitch.tv/kraken/channels/#{@user.downcase}/follows?limit=1")
      @res = Net::HTTP.start(@uri.host, @uri.port,
                              :use_ssl => @uri.scheme == 'https') do |http|
        req = Net::HTTP::Get.new @uri
        req['Client-ID'] = @clientID
        req['Authorization'] = "OAuth #{@userOauth}"
        http.request req
      end
      response = JSON.parse @res.body
      follows = response['follows']
      if !Follower.exists?(name: f['user']['display_name'])
        follower = Follower.new
        follower.name = f['user']['display_name']
        follower.points = 100
        follower.save
      end
      sleep 1.minutes
    end
  end

  def start
    if @type == "point"
      pointTracker
    elsif @type == "follower"
      followTracker
    end
  end

  def quit
    @stop = false
    puts "Closing Tracker Type: #{@type}"
  end
end
