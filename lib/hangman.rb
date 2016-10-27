class Hangman
  def initialize()
    @guesses = 12
  end

  def pick_random_word()
    dictionary = File.readlines("5desk.txt")
    random_line = rand(1..61405)
    secret_word = dictionary[random_line]
    while((secret_word.length < 6) || (secret_word.length > 13))
      random_line = rand(1..61405)
      secret_word = dictionary[random_line]
    end
    return secret_word.downcase
  end

  def run()
    secret_word = pick_random_word()
    while @guesses > 0
      puts "guesses: #{@guesses}"
      (secret_word.length).times do
        print "_ "
      end
      print "\n"
      @guesses -= 1
    end

  end

end

game = Hangman.new()
game.run()