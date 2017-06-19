require 'cinch'
class Hello
  include Cinch::Plugin

  match "hello", method: :selfHello
  match /hello (.+)/, method: :sayHello

  def selfHello(m)
    m.reply "Hello, #{m.user.nick}"
  end
  def sayHello(m, user)
    m.reply "Hello, @#{user}"
  end
end
