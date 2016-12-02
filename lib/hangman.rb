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

  def assign_secret_word()
    @secret_word = pick_random_word()
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
    if(@guess_letter_blanks.join() == secret_word)
      return :game_over
    elsif(@load_state == true)
      puts "Cannot evaluate at this time."
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

  def save(guesses, secret_word, guess_letter_blanks, incorrect_letters)
    CSV.open("saved_games.csv", "w") do |csv|
      csv << [guesses.to_s]
      csv << [secret_word]
      csv << [guess_letter_blanks.to_s]
      csv << [incorrect_letters.to_s]
    end
  end

  def load()
    load_data = CSV.read("saved_games.csv",converters: :all)
    @guesses = load_data[0][0]
    @secret_word = load_data[1][0]
    @guess_letter_blanks = load_data[2][0].split(",")
    @incorrect_letters = load_data[3]
    puts "*TEST GLB*"
    puts @guess_letter_blanks
    puts @incorrect_letters
    puts "*END GLB TEST*"
    @load_state = true
  end

  def run()
    puts "Would you like to load a saved game? Type 'yes' if so, and 'no' if you'd like a new game. Type 'exit' to quit."
    load_game = gets.chomp
    human_guess = nil
    if(load_game == "yes")
      puts "game retrieved!"
      load()
      puts "\n\n"
      puts @incorrect_letters
      puts @guesses.class
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
      puts @guess_letter_blanks.class
      puts @guess_letter_blanks[2]
      puts @guess_letter_blanks[2].class
      @guess_letter_blanks.each_with_index {|a, i| puts "#{a}, #{a.class}, #{i}"}
      print "\n"
      print "Save your game? Type 'Y'. Type 'exit' to quit at anytime w/o saving."
      save = gets.chomp
      if(save == "Y")
        save(@guesses, @secret_word, guess_letter_blanks, @incorrect_letters)
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