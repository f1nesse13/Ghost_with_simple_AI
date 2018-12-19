require "set"
require_relative "player"
require_relative "ai_player"

class Ghost

    attr_reader :fragment, :dictionary, :losses, :players, :rounds
    attr_writer :rounds, :players

    ALPHABET = Set.new("a".."z")

    def initialize(*players)
        @players = players
        @words = File.readlines(".\\dictionary.txt").map(&:chomp)
        @dictionary = Set.new(@words)
        @standings = Hash.new { |k, v| @standings[k] = 0}
    end

    def run
        puts "\nEnter a letter without spelling a word - if you do you get a letter! Spell the word GHOST and lose the game!"
        play_round until game_over?
        puts "#{current_player.name} wins!"
        puts "The final standings were: "
        print_standings
    end

    def play_round
        @fragment = ""
        puts "\nThe current standings are :"
        print_standings
        until round_over?
            puts "The fragment is #{fragment}" if fragment != ""
            take_turn
            if round_over?
                add_loss
                eliminate_player
            end
            switch_player
        end
    end

    def print_standings
        ghost = [" ", "G", "H", "O", "S", "T"]
        puts "----------------------------"
        players.each do |player|
        puts "#{player.name} :  #{ghost[0..@standings[player]].join("")}"
        end
        puts "----------------------------"
    end

    def eliminate_player
        players.each do |player|
            if @standings[player] == 5
                puts "#{player.name} has been eliminated!"
                players.delete(player)

            end
        end
        players
    end

    def current_player
        players.first
    end

    def switch_player
        players.rotate!
    end

    def add_loss
        puts "#{current_player.name} has lost the round\n"
        @standings[current_player] += 1
    end

    def word_valid?(letter)
        return false unless ALPHABET.include?(letter)
        temp = fragment + letter
        dictionary.any? { |word| word.start_with?(temp) }
    end

    def check_word(fragment)
        dictionary.include?(fragment)
    end

    def round_over?
        check_word(fragment)
    end

    def add_letter(letter)
        fragment << letter
    end

    def game_over?
        if round_over? && players.length == 1
            true
        end
    end

    def take_turn
        guess = nil
        until guess
            if current_player.name == "AI"
                guess = current_player.search_valid(fragment)
            else
                guess = current_player.enter_letter
            end
            unless word_valid?(guess)
                puts "The letter entered needs to be part of a word to be considered valid. No random letters allowed \n"
                puts "Please enter a valid letter: "
                guess = nil
            end
        end

        add_letter(guess)
        puts "\n#{guess.upcase} has been added to the fragment\n\n"
    end


end

if __FILE__ == $PROGRAM_NAME
    game = Ghost.new(Player.new("Joe"), Ai_Player.new)
    game.run
end