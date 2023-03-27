# frozen_string_literal: true

# Game Class
class Game
  def initialize
    @secret_word = select_word
  end

  attr_reader :secret_word

  # Randomly select a word between 5 & 12 characters long
  def select_word
    dict_arr = []

    dictionary = File.readlines('dictionary.txt')
    dictionary.each do |word|
      dict_arr << word.gsub("\n", '') if word.length >= 5 && word.length <= 12
    end

    dict_arr.sample
  end
end

new_game = Game.new
puts new_game.secret_word
