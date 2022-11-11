class WordsController < ApplicationController
  def new
    session[:score] = 0 if session[:score].nil?
    alphabet = ('a'..'z').to_a
    @letters = 10.times.map { alphabet.sample }
  end

  def score
    @answer = params[:answer]
    @letters = params[:letters].split
    @result = result(@answer, @letters)
    @score = session[:score]
  end

  def letter_check(answer, letters)
    answer.downcase.each_char do |l|
      return false unless letters.include?(l)

      letters.delete_at(letters.index(l.downcase))
    end
    true
  end

  def result(answer, letter)
    if letter_check(answer, letter)
      return "Congratulations #{answer} is a valid English word!" && session[:score] += 1 if word_check(answer)

      "Sorry but #{answer} is not a valid English word"
    else
      "Sorry but #{answer} can not be build out of #{params[:letters]}"
    end
  end

  def word_check(answer)
    url_read = URI.open("https://wagon-dictionary.herokuapp.com/#{answer}").read
    url_json = JSON.parse(url_read)
    url_json['found']
  end
end
