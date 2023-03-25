# frozen_string_literal: true

def select_word
  dict_arr = []

  dictionary = File.readlines('dictionary.txt')
  dictionary.each do |word|
    dict_arr << word.gsub("\n", '') if word.length >= 5 && word.length <= 12
  end

  dict_arr.sample
end

puts select_word
