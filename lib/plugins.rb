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

class Points
  include Cinch::Plugin
  @@config = PointConfig.find(1)

  match "#{@@config.name}"

  def execute m
    @@user = Follower.where('lower(name) = ?', m.user.nick.downcase)
    m.reply "#{m.user.nick} has #{@@user[0].points} #{@@config.name}"
  end


end
