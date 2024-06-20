require 'set'
require 'open-uri'
require 'json'
require 'time'

class GamesController < ApplicationController
  def new
    alphabet = Array("A".."Z")
    @letters = []
    10.times do
      @letters << alphabet.sample
    end
    @start_time = Time.now
  end

  def score
    session[:score] ||= 0
    @word = params[:word].upcase
    end_time = Time.now
    @time = (end_time - Time.parse(params[:start_time])).round
    set_word = Set.new(@word.chars)
    set_grid = Set.new(params[:letters].chars)
    url = "https://dictionary.lewagon.com/#{@word}"
    uri = URI.open(url).read
    json = JSON.parse(uri)
    result = json["found"]
    if set_word.subset?(set_grid)
      if result == true
        @message = "Well done!"
        @score = (200/@time + @word.length * 5).round
      else
        @message = "Sorry your word is not a word"
        @score = 0
      end
    else
      @message = "Sorry your word is not in the grid"
      @score = 0
    end
    session[:score] += @score
    @total_score = session[:score]
    # render 'score'
  end
end
