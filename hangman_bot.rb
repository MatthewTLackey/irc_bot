require "socket"
#require "./hangman"

class Hangman
  def initialize(irc_server, channel)
    
    @irc_server = irc_server
    @channel = channel
    # @irc_server.puts "PRIVMSG #{@channel} Enter a new word."
    # input = @irc_server.gets
    # input.split(":")
    # @word = input[-1]

    @word = gets.chomp
    @past_guesses = []
    @hang_val = 0
  end

  def hide_word
    @user_word = @word.gsub(/\w/, "_")
    puts @user_word
    @irc_server.puts "PRIVMSG #{@channel} : #{@user_word}"
  end

  def ask_for_guess
    puts "Guess a letter"
    @irc_server.puts "PRIVMSG #{@channel} : Guess a letter."
    #@guess = gets.chomp

    input = @irc_server.gets
    input.split(":")
    @guess = input[-1]
    puts "You guessed #{@guess}"
  end

  def check_for_matches
    index = 0
    @word.each_char do |letter|
      if letter == @guess
        @user_word[index] = letter
      end
      index += 1
    end
    @past_guesses << @guess
    puts "\e[H\e[2J"

    puts @user_word
    @irc_server.puts "PRIVMSG #{@channel} : #{@user_word}"
    puts "Previous guesses:"
    @irc_server.puts "PRIVMSG #{@channel} : Previous guesses:"
    print_previous_guesses
  end

  def choose_word
    #puts "Enter a new word."
    @irc_server.puts "PRIVMSG #{@channel} Enter a new word."
    
    input = @irc_server.gets
    input.split(":")
    @word = input[-1]
  end

  def play
    #choose_word
    hide_word
    while @user_word != @word && @hang_val < 7
      ask_for_guess
      check_for_matches
      if match_found?
        puts "It's a match"
      else
        @hang_val += 1
        hang_him
      end
    end
  end

  def print_previous_guesses
    @past_guesses.each do |x| print x;
      @irc_server.print "PRIVMSG #{@channel} : #{x}" 
    puts ""
    end
  end

  def hang_him
    puts "No match! Let's hang 'em!"
    @irc_server.puts "PRIVMSG #{@channel} : No match! Let's hang 'em!"
    puts "He has a:"
    @irc_server.puts "PRIVMSG #{@channel} : He has a: "
    body_array = ["Head O", "Torso |", "Left arm /", "Right arm \\", "Left leg /", "Right leg \\", "You hung him! You really did it! Who hangs people? That's awful.\nCut him down. The word is '#{@word}'."]
    @counter = 0
    until @counter == @hang_val
      puts body_array[@counter]
      @irc_server.puts "PRIVMSG #{@channel} : #{body_array[@counter]}"
      @counter += 1
    end 
  end

  def match_found?
    return_val = false
    index = 0
    @word.each_char do |letter|
      if letter == @guess
        @user_word[index] = letter
        return_val = true
      end
      index += 1
    end
    return_val
  end
end












server = "chat.freenode.net"
port = "6667"
nick = "Lynch_Bot"
channel = "#bitmaker"
greeting_prefix = "privmsg #{channel} :"
activators = ["hang him!", "lynch him"]

irc_server = TCPSocket.open(server, port)

irc_server.puts "USER bhellobot 0 * BHelloBot"
irc_server.puts "NICK #{nick}"
irc_server.puts "JOIN #{channel}"
irc_server.puts "PRIVMSG #{channel}"
#{}" :Hello from IRC Bot"
a_game = Hangman.new(irc_server, channel)
# Hello, Bot!
until irc_server.eof? do
  msg = irc_server.gets.downcase
  puts msg

  was_addressed = false
  activators.each do |g|
    was_addressed = true if msg.include?(g)
  end

  if msg.include?(greeting_prefix) and was_addressed
    response = "Are you sure you want to play hangman?"
    irc_server.puts "PRIVMSG #{channel} :#{response}"
  elsif msg.include?("yep")
    response = "Here we go."
    irc_server.puts "PRIVMSG #{channel} :#{response}"
    
    a_game.play
   # Hangman.play
  end
end






