class Hangman
require "csv"
  def initialize()
    @guesses = 12
    @incorrect_letters = []
  end

  def pick_random_word()
    dictionary = File.readlines("5desk.txt")
    random_line = rand(1..61405)
    secret_word = dictionary[random_line]
    while((secret_word.length < 6) || (secret_word.length > 13))
      random_line = rand(1..61405)
      secret_word = dictionary[random_line]
    end
    return secret_word.downcase.chomp
  end

  def collect_incorrect_letters(human_guess)
    @incorrect_letters << human_guess
  end

  def find_letter_matches(secret_word, guess_letter_blanks, human_guess)
    secret_word.split(//).each_with_index do |letter, index|
      if(letter == human_guess)
        guess_letter_blanks[index] = letter
      end
    end
    if(secret_word.include?(human_guess) == false)
      collect_incorrect_letters(human_guess)
    end
  end

  def game_over(guess_letter_blanks, secret_word)
    if(guess_letter_blanks.join() == secret_word)
      return :game_over
    else
      :not_yet
    end
  end

  def game_over_message(message, secret_word)
    if(message == :game_over)
      puts "Congrats, you won in only #{12 - @guesses} guesses! The word was #{secret_word}."
      exit
    elsif(message == :not_yet) && (@guesses == 0)
      puts "Oh no, you did not guess the word in time! The word was #{secret_word}."
    end
  end

  def run()
    secret_word = pick_random_word()
    guess_letter_blanks = []
    human_guess = nil
    (secret_word.length).times do
      guess_letter_blanks << "_ "
    end
    puts "Would you like to load a saved game? Type 'yes' if so, and 'no' if you'd like a new game."
    load_save = gets.chomp
    if(load_save == "yes")
      puts "game retrieved!"
      CSV.parse("saved_games.csv") do |row|
        @guesses = row[0]
        secret_word = row[1]
        guess_letter_blanks = row[2]
        @incorrect_letters = row[3]
      end
    else
        while @guesses > 0
          puts "guesses: #{@guesses}"
          puts "Incorrect Guesses: #{@incorrect_letters.join()}"
          puts guess_letter_blanks.join()
          print "\n"
          print "Would you like to save your game? Type 'Y' if yes."
          save = gets.chomp
          if(save == "Y")
            CSV.open("saved_games.csv", "wb") do |csv|
              csv << [@guesses, secret_word, guess_letter_blanks, @incorrect_letters]
            end
          end
          print "\n"
          print "Guess a letter:"
          human_guess = gets.chomp
          @guesses -= 1
          find_letter_matches(secret_word, guess_letter_blanks, human_guess)
          message = game_over(guess_letter_blanks, secret_word)
          game_over_message(message, secret_word)
        end
    end
  end

end

game = Hangman.new()
game.run()