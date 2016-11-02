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

  def find_letter_matches(secret_word, guess_letter_blanks, human_guess)
    puts secret_word
    puts guess_letter_blanks.join()
    puts human_guess
    secret_word.split(//).each_with_index do |letter, index|
      if(letter == human_guess)
        guess_letter_blanks[index] = letter
      end
    end

  end

  def run()
    secret_word = pick_random_word()
    guess_letter_blanks = []
    human_guess = nil
    (secret_word.length).times do
      guess_letter_blanks << "_ "
    end
    while @guesses > 0
      puts "guesses: #{@guesses}"
      puts guess_letter_blanks.join()
      print "\n"
      print "Guess a letter:"
      human_guess = gets.chomp
      @guesses -= 1
      find_letter_matches(secret_word, guess_letter_blanks, human_guess)
    end

  end

end

game = Hangman.new()
game.run()