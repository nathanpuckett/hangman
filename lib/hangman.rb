# frozen_string_literal: true

require 'yaml'

# Game Class
class Game
  def initialize
    @secret_word = select_word
    @current_guess = guess_init
    @incorrect_letters = []
    @turns_left = @secret_word.length + 1
  end

  def to_yaml
    YAML.dump({
                secret_word: @secret_word,
                current_guess: @current_guess,
                incorrect_letters: @incorrect_letters,
                turns_left: @turns_left
              })
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
    catch(:end_game) do
      loop do
        print_board

        user_input

        throw :end_game if word_guessed?
        throw :end_game if out_of_guesses?
      end
    end
  end

  def print_board
    puts "\n#{@current_guess.join(' ')}"
    puts "\nIncorrect Letters: #{@incorrect_letters.join(' ')}"
    puts "\nTurns Left: #{@turns_left}"
  end

  def user_input
    print "\nGuess A Letter (Or Input 'save' To Save Your Game): "
    input = gets.chomp
    if input == 'save'
      save_game
    else
      make_guess(input.upcase)
    end
  end

  def save_game
    Dir.mkdir('saved_games') unless Dir.exist?('saved_games')

    filename = 'saved_games/game.yaml'

    File.open(filename, 'w') { |file| file.write(to_yaml) }

    puts "\nGame Saved! See You Next Time."
    throw :end_game
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

# rubocop:disable Lint/MissingSuper

# SavedGame Class
class SavedGame < Game
  def initialize(secret_word, current_guess, incorrect_letters, turns_left)
    @secret_word = secret_word
    @current_guess = current_guess
    @incorrect_letters = incorrect_letters
    @turns_left = turns_left
  end

  def self.from_yaml(save_file)
    data = YAML.load save_file
    self.new(data[:secret_word], data[:current_guess], data[:incorrect_letters], data[:turns_left])
  end
end

# rubocop:enable Lint/MissingSuper

print 'Welcome To Hangman! Would You Like To Open A Saved Game? (y/n): '
input = gets.chomp

case input
when 'y'
  SavedGame.from_yaml(File.read('saved_games/game.yaml')).play
when 'n'
  Game.new.play
end
