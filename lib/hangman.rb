# frozen_string_literal: true

# Game Class
class Game
  def initialize
    @secret_word = select_word
    @current_guess = guess_init
    @incorrect_letters = []
    @turns_left = 12
  end

  def select_word
    dict_arr = []

    dictionary = File.readlines('dictionary.txt')
    dictionary.each do |word|
      dict_arr << word.gsub("\n", '').upcase if word.length >= 5 && word.length <= 12
    end

    dict_arr.sample.split('')
  end

  def guess_init
    guess_arr = []
    @secret_word.length.times { guess_arr << '_' }
    guess_arr
  end

  def play
    puts @secret_word.join
    loop do
      print_board

      print "\nGuess A Letter: "
      make_guess(gets.chomp.upcase)

      return if word_guessed?
      return if out_of_guesses?
    end
  end

  def print_board
    puts "\n#{@current_guess.join(' ')}"
    puts "\nIncorrect Letters: #{@incorrect_letters.join(' ')}"
    puts "\nTurns Left: #{@turns_left}"
  end

  def make_guess(guess)
    is_correct = false
    @secret_word.each_with_index do |l, i|
      if guess == l
        @current_guess[i] = l
        is_correct = true
      end
    end
    @incorrect_letters << guess unless is_correct
    @turns_left -= 1
  end

  def word_guessed?
    if @secret_word == @current_guess
      puts "\n#{@current_guess.join(' ')}"
      puts "\nCongratulations! You Guessed The Word Correctly."
      true
    else
      false
    end
  end

  def out_of_guesses?
    if @turns_left.zero?
      puts "\nBummer! You Ran Out Of Turns."
      puts "\nThe Word Was '#{@secret_word.join}'"
      true
    else
      false
    end
  end
end

Game.new.play
