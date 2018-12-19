require_relative "ghost"

class Player

    attr_reader :name

    def initialize(name)
        @name = name
    end

    def enter_letter
            print "\n#{@name} enter a valid letter: "
            gets.chomp.downcase
    end

end