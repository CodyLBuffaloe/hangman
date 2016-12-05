class Hangman
require "csv"
  def initialize()
    @guesses = 12
    @incorrect_letters = []
    @load_state = false
    @secret_word
    @guess_letter_blanks = []
    load_state = false
  end

#picks a random word from our dowloaded dictionary
  def pick_random_word()
    dictionary = File.readlines("5desk.txt")
    random_line = rand(1..61405)
    chosen_word = dictionary[random_line]
    while((chosen_word.length < 6) || (chosen_word.length > 13))
      random_line = rand(1..61405)
      chosen_word = dictionary[random_line]
    end
    chosen_word.downcase.chomp
  end

#assigns result of pick_random_word to @secret_word
  def assign_secret_word()
    @secret_word = pick_random_word()
  end

#pushes incorrect guess to @incorrect_letters array
  def collect_incorrect_letters(human_guess)
    @incorrect_letters << human_guess
  end

#tests the human_guess from run method to see if it's included in @secret_word
#if it is included, it is displayed in @guess_letter_blanks
#if the human_guess is not included in @secret_word, it is sent to collect_incorrect_letters method
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

#defines whether or not the game has been won or not
  def game_over(guess_letter_blanks, secret_word)
    if(@guess_letter_blanks.join() == secret_word)
      return :game_over
    else
      :not_yet
    end
  end

#returns the status of game_over to the player, either they won or they didn't.
  def game_over_message(message, secret_word)
    if(message == :game_over)
      puts "Congrats, you won in only #{12 - @guesses} guesses! The word was #{secret_word}."
      exit
    elsif(message == :not_yet) && (@guesses == 0)
      puts "Oh no, you did not guess the word in time! The word was #{secret_word}."
    end
  end

#writes game data to CSV at time of save.
  def save(guesses, secret_word, guess_letter_blanks, incorrect_letters)
    puts secret_word.length()
    CSV.open("saved_games.csv", "w") do |csv|
      csv << [guesses]
      csv << [secret_word]
      csv << guess_letter_blanks
      csv << incorrect_letters
    end
  end

#reads data saved to CSV back into the game
  def load()
    load_data = CSV.read("saved_games.csv",converters: :all)
    @guesses = load_data[0][0]
    @secret_word = load_data[1][0]
    @guess_letter_blanks = load_data[2]
    @incorrect_letters = load_data[3]
    @load_state = true
  end

#runs the actual game
#Asks if you would like to load the saved game, if yes, it then loads a previously started game
#If you type No, it starts a new game, picking a new random word and assigning it to you
#For each correct letter you guess, it's places in @guess_letter_blanks are filled
#For each incorrect letter you guess, it's sent to @incorrect_letters and displayed above @guess_letter_blanks
#If you run out of guesses before you fill in GLB, you lose
#If you fill out the correct word, it's checked in game_over and if correct, you win
  def run()
    puts "Would you like to load a saved game? Type 'yes' if so, and 'no' if you'd like a new game. Type 'exit' to quit."
    load_game = gets.chomp
    human_guess = nil
    if(load_game == "yes")
      puts "game retrieved!"
      load()
    elsif(load_game == "exit")
      exit
    else
      assign_secret_word()
      (@secret_word.length).times do
        @guess_letter_blanks << "_ "
      end
    end

    while @guesses > 0
      puts "guesses: #{@guesses}"
      puts "Incorrect Guesses: #{@incorrect_letters.join()}"
      puts @guess_letter_blanks.join()
      print "\n"
      print "Save your game? Type 'Y'. Type 'exit' to quit at anytime w/o saving."
      save = gets.chomp
      if(save == "Y")
        save(@guesses, @secret_word, @guess_letter_blanks, @incorrect_letters)
      elsif(save == "exit")
        exit
      end
      print "\n"
      print "Guess a letter:"
      human_guess = gets.chomp
      @guesses -= 1
      find_letter_matches(@secret_word, @guess_letter_blanks, human_guess)
      message = game_over(@guess_letter_blanks, @secret_word)
      game_over_message(message, @secret_word)
    end
  end

end

game = Hangman.new()
game.run()