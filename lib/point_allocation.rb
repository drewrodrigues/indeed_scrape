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
    points >= PASSING_POINTS
  end

  private

  attr_writer :points

  def allocate(text)
    allocate_good_matches(text)
    allocate_bad_matches(text)
  end

  def allocate_good_matches(text)
    SETTINGS[:good_keywords].each do |word, value|
      matches = text.scan(word).uniq
      match_count = matches.count
      unless match_count.zero?
        self.points += value
        good_matches.concat(matches)
      end
    end
  end

  def allocate_bad_matches(text)
    SETTINGS[:bad_keywords].each do |word, value|
      matches = text.scan(word).uniq
      match_count = matches.count
      unless match_count.zero?
        self.points += value
        bad_matches.concat(matches)
      end
    end
  end
end