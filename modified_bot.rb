require "socket"

server = "chat.freenode.net"
port = "6667"
nick = "Canadian_Bot"
channel = "#bitmaker"
greeting_prefix = "privmsg #{channel} :"
greetings = ["hello", "hi", "hola", "yo", "wazup", "guten tag", "howdy", "salutations", "who the hell are you?"]

irc_server = TCPSocket.open(server, port)

irc_server.puts "USER bhellobot 0 * BHelloBot"
irc_server.puts "NICK #{nick}"
irc_server.puts "JOIN #{channel}"
irc_server.puts "PRIVMSG #{channel} :Hello from IRC Bot"

# Canada, Bot!
until irc_server.eof? do
  msg = irc_server.gets.downcase
  puts msg

  was_greeted = false
  greetings.each do |g|
    was_greeted = true if msg.include?(g)
  end

  #if msg.include?(greeting_prefix) && msg.include?("Canada")
        if msg.include?("Canada")
          response = "I showed up with some maple syrup. Would you like some maple syrup?"
          irc_server.puts "PRIVMSG #{channel} :#{response}"
  
  elsif msg.include?("syrup")
    response = "Well then how aboot some french fries and gravy"
    irc_server.puts "PRIVMSG #{channel} :#{response}"

    elsif msg.include?("gravy") || msg.include?("french fries")
      response = "Well, I realize poutine's not healthy. Sports are healty, though!"
    irc_server.puts "PRIVMSG #{channel} :#{response}"
  
  elsif msg.include?("sports")
    response = "I love hockey! Go Leafs!"
    irc_server.puts "PRIVMSG #{channel} :#{response}"
  elsif msg.include?("beer")
    response = "I love Molson!"
    irc_server.puts "PRIVMSG #{channel} :#{response}"
  elsif msg.include?("living")
    response = "I'm a retired Mounty."
    irc_server.puts "PRIVMSG #{channel} :#{response}"

  end
end