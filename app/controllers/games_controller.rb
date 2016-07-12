class GamesController < ApplicationController
  def play
    @grid = generate_grid(9)
  end

  private

  def generate_grid(grid_size)
    # TODO: generate random grid of letters
    random_letters = []
    while random_letters.size < grid_size
      letter = ("A".."Z").to_a.sample
      random_letters << letter
    end
    random_letters
  end
end
