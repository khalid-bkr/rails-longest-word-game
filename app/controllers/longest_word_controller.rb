require 'time'
class LongestWordController < ApplicationController
  def game

  end

  def home
  end

  def score
    @result= run_game(params[:question] , params[:grid], Time.parse(params[:s_time]) , Time.now)
  end

  def run_game(attempt, grid, start_time, end_time)
  # TODO: runs the game and return detailed hash of result
  url = "https://api-platform.systran.net/translation/text/translate?source=en&target=fr&key=a972a1bc-24de-4eac-a668-8c0362161294&input=#{attempt}"
  link = open(url).read
  translation = JSON.parse(link)
  words = File.read('/usr/share/dict/words').upcase.split("\n")
  res = { translation: translation["outputs"][0]["output"] , score: 0, message: "", time: end_time - start_time}
  res[:score] = ((attempt.size * 2) / res[:time]).to_f
  res[:translation] = translation["outputs"][0]["output"]
  if valid(attempt, grid)
    unless words.include?(attempt.upcase)
      res[:score] = 0
      res[:translation] = nil
      res[:message] = "not an english word"
    else
      res[:translation] = translation["outputs"][0]["output"]
      res[:message] = "well done"
    end
  else
    res[:score] = 0
    res[:message] = "not in the grid"
  end
  return res
  end

  def valid(att,grid)
    g = []
    attempt = att.upcase.split("")
    attempt.each do |x|
      # byebug
      if grid.split("").include?(x)
        g.push(x)
        grid.split("").delete_at(grid.split("").index(x))
      end
    end
    return g.sort == attempt.sort
  end


end
