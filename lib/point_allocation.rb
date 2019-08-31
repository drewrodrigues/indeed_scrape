require 'colorize'

class PointAllocation
  attr_reader :points,        # Integer: point allocation
              :good_matches,  # [<String>]: good key words that were matched
              :bad_matches    # [<String>]: bad key words that were matched

  # setup good and bad keywords to be used in all objects
  def self.options(options = {})
    const_set('GOOD_KEY_WORDS', options[:good_key_words])
    const_set('BAD_KEY_WORDS', options[:bad_key_words])
    const_set('PASSING_POINTS', options[:passing_points])
  end

  def initialize(text)
    GOOD_KEY_WORDS && BAD_KEY_WORDS && PASSING_POINTS
    @points = 0
    @bad_matches = []
    @good_matches = []
    text = text.downcase
    allocate(text)
  rescue NameError
    raise 'Good & bad key words must be set.'
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
    GOOD_KEY_WORDS.each do |word, value|
      matches = text.scan(word).uniq
      match_count = matches.count
      unless match_count.zero?
        self.points += value
        good_matches.concat(matches)
      end
    end
  end

  def allocate_bad_matches(text)
    BAD_KEY_WORDS.each do |word, value|
      matches = text.scan(word).uniq
      match_count = matches.count
      unless match_count.zero?
        self.points += value
        bad_matches.concat(matches)
      end
    end
  end
end