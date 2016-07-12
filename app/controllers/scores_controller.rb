require 'open-uri'
require 'json'

class ScoresController < ApplicationController
  def display
    grid        = params[:grid].split(" ")
    @attempt    = params[:shot].strip
    start_time  = params[:start_time].to_i
    end_time    = Time.now.to_i
    @results    = run_game(@attempt, grid, start_time, end_time)
  end

  private

  def run_game(attempt, grid, start_time, end_time, translation = nil)
    # TODO: runs the game and return detailed hash of result
    time = end_time - start_time
    score = (attempt.size * 100) / time
    translation = call_api(attempt)
    if in_the_grid?(attempt, grid) == false
      { time: time, score: 0, translation: translation, message: "not in the grid" }
    elsif translation
      { time: time, score: score, translation: translation, message: "well done" }
    else
      { time: time, score: 0, translation: translation, message: "not an english word" }
    end
  end

  def in_the_grid?(word, grid)
    word.chars.each do |letter|
      return false unless grid.include?(letter.upcase)
      index = grid.find_index(letter.upcase)
      grid.delete_at(index)
    end
    true
  end

  def call_api(attempt)
    api_url = "http://api.wordreference.com/0.8/80143/json/enfr/#{attempt}"
    open(api_url) do |stream|
      quote = JSON.parse(stream.read)
      if quote["term0"]
        translation = quote["term0"]["PrincipalTranslations"]["0"]["FirstTranslation"]["term"]
      end
      translation
    end
  end
end
