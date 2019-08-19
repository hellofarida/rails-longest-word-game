require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    @random_letters = ('a'..'z').to_a.sample(10)
  end

  def included?(guess, grid)
    guess.chars.all? { |letter| grid.count(letter) <= grid.count(letter) }
  end

  def score
    @attempt = params[:word]

    url = "https://wagon-dictionary.herokuapp.com/#{@attempt}"
    read_url = open(url).read # Open file & read
    @print_page = JSON.parse(read_url) # Turns into hash

    @word_score = @print_page['length']
    @confirmation = if included?(@attempt, new)
                      check_word
                    else
                      "Use letters from the grid plz"
                    end
  end

  private

  def check_word
    if @print_page['found'] == false
      "Nice try but #{@print_page['word']} is not a word #soz 😈"
    else
      "Congratulations, #{@print_page['word']} is totes valid 💅🏾"
    end
  end
end
