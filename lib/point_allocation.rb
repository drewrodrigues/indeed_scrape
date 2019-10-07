require 'colorize'
require_relative '../config/settings'

class PointAllocation
  attr_reader :points,        # Integer: point allocation
              :good_matches,  # [<String>]: good key words that were matched
              :bad_matches    # [<String>]: bad key words that were matched

  def initialize(text)
    @points = 0
    @bad_matches = []
    @good_matches = []
    text = text.downcase
    allocate(text)
  end

  def passing_score?
    points >= SETTINGS[:passing_points]
  end

  private

  attr_writer :points

  def allocate(text)
    allocate_good_matches(text)
    allocate_bad_matches(text)
  end

  def allocate_good_matches(text)
    match(SETTINGS[:good_keywords], text, :good_matches)
  end

  def allocate_bad_matches(text)
    match(SETTINGS[:bad_keywords], text, :bad_matches)
  end

  def match(keywords, text, attribute)
    keywords.each do |word, value|
      if text.scan(word)
        self.points += value
        send(attribute) << word
      end
    end
  end
end