require 'cinch'
class Hello
  include Cinch::Plugin

  match "hello", method: :selfHello
  match /hello (.+)/, method: :sayHello

  def selfHello m
    m.reply "Hello, #{m.user.nick}"
  end
  def sayHello m, user
    m.reply "Hello, @#{user}"
  end
end

# class Points
#   include Cinch::Plugin
#   @@config = PointConfig.find(1)
#
#   match "#{@@config.name}"
#
#   def execute m
#     @@user = Follower.where('lower(name) = ?', m.user.nick.downcase)
#     m.reply "#{m.user.nick} has #{@@user[0].points} #{@@config.name}"
#   end
# end

class Commands
  include Cinch::Plugin

  $multi1 = "shemerson"
  $multi2 = "astrovance"
  $multi3 = ""
  $multi4 = ""
  @command = Command.all

  match /[sS]houtout (.+)/, method: :shoutout
  match /[aA]strovance/, method: :astrovance
  match /[sS]treamer[nN]ation/, method: :streamernation
  match /[tT]witter/, method: :twitter
  match /[cC]ommands/, method: :commands
  match /[sS]chedule/, method: :schedule
  match /[sS]hembot/, method: :shembot
  match /[mM]ulti/, method: :multi
  match /[eE]dit[mM]ulti ([^\n\r\s]+)+ ([^\n\r\s]+)+\s*([^\n\r\s]+)*\s*([^\n\r\s]+)*/, method: :editmulti

  @command.each do |c|
    i = 0
    j = 0
    methodname = c.name
    message = ""
    replacements = []
    regex = "#{c.name} "
    while i < c.args do
      arg = "arg" << i
      regex << "([^\\n\\r\\s]+)*\\s*"
      replacements << [/\[#{arg}\]/, "#{args[i]}"]
      i += 1
    end
    match /#{regex}/i, method: methodname


    define_method c.name do |m, *args|
      replacements.each {|replacement| message.gsub!(replacement[0], replacement[1])}
      m.reply "#{message}"
    end

  end
  # timer 900, method: :twittertimer
  def shoutout m, user
    m.reply "Shoutout to #{user} check them out at https://twitch.tv/#{user}"
  end

  def astrovance m
    m.reply "I sometimes play with this random guy, His name's Astrovance, go send him some love at https://twitch.tv/astrovance"
  end

  def streamernation m
    m.reply "I'm part of this wonderful Community of streamers, Streamer Nation. Check out #streamernation on Twitter and at https://twitch.tv/nationofstreamers"
  end

  def twitter m
    m.reply "Follow me on Twitter for stream updates and such at https://twitter.com/Shemerson4"
  end

  def twittertimer
    Channel("#shemerson").send "Follow me on Twitter for stream updates and such at https://twitter.com/Shemerson4"
  end

  def shembot m
    m.reply "My bot is called Shembot v0.1, it's still early in development so it's functionality is limited, but it will be improved in the future. Feel free to ask any questions about and use the command !commands for teh command list."
  end

  def commands m
    m.reply "Shembot 0.1 Commands: !shoutout Username, !astrovance, !streamernation, !twitter, commands, !schedule, !shembot"
  end

  def schedule m
    m.reply "I usually stream monday to friday, starting around 1PM EST with some bonus streams on the weekend."
  end

  def editmulti (m, u1, u2, u3, u4)
    $multi1 = u1
    $multi2 = u2
    $multi3 = u3
    $multi4 = u4
    m.reply "Multitwitch link updated, use command !multi to view the new link."
  end

  def multi m
    m.reply "Check out everyone I'm playing with all at once at http://multitwitch.tv/#{$multi1}/#{$multi2}/#{$multi3}/#{$multi4}"
  end

end
