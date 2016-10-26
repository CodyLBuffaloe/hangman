class Hangman
  def initialize()
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
    puts secret_word
  end

end

game = Hangman.new()
game.run()