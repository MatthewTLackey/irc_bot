require "socket"

server = "chat.freenode.net"
port = "6667"
nick = "HelloBot"
channel = "#bitmaker"
greeting_prefix = "privmsg #{channel} :"
greetings = ["hello", "hi", "hola", "yo", "wazup", "guten tag", "howdy", "salutations", "who the hell are you?"]

irc_server = TCPSocket.open(server, port)

irc_server.puts "USER bhellobot 0 * BHelloBot"
irc_server.puts "NICK #{nick}"
irc_server.puts "JOIN #{channel}"
irc_server.puts "PRIVMSG #{channel} :Hello from IRC Bot"

# Hello, Bot!
until irc_server.eof? do
  msg = irc_server.gets.downcase
  puts msg

  was_greeted = false
  greetings.each do |g|
    was_greeted = true if msg.include?(g)
  end

  if msg.include?(greeting_prefix) and was_greeted
          response = "w00t! Someone talked to us!!!! Hello!!!"
          irc_server.puts "PRIVMSG #{channel} :#{response}"
  end
end