
class Ai_Player

    ALPHABET = ("a".."z")

    attr_reader :name,  :dictionary
    attr_writer :possible_letters

    def initialize(name="AI")
        @name = name
        @words = File.readlines(".\\dictionary.txt").map(&:chomp)
        @dictionary = Set.new(@words)
    end

    def add_possibilities(fragment)
        possible_letters = []
        ALPHABET.each do |char|
            dictionary.each do |word|
                if word.start_with?("#{fragment}#{char}") || dictionary.include?("#{fragment}#{char}")
                    possible_letters << char if !possible_letters.include?(char)
                end
            end
        end
        possible_letters
    end

    def search_valid(fragment)
         valid = add_possibilities(fragment)
         best_choice = valid.select do |letter|
            if !dictionary.include?("#{fragment}#{letter}")
                letter
            end
        end
        best_choice.length == 0 ? valid.sample : best_choice.sample
    end

end