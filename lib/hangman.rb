class Hangman

    def initialize()
    end

    def pick_random_word()
      line_number = 0
       File.open("5desk.txt").each do |line|
         if((line.size > 5) && (line.size < 14))
           puts "#{line}__#{(line_number += 1)}"
         end
       end
    end

    def run()
      secret_word = pick_random_word()
      puts secret_word
    end

end

game = Hangman.new()
game.pick_random_word()