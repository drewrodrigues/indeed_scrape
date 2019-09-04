require_relative 'point_allocation'
require 'colorize'

# Keep track of job posting data
class JobPosting
  ATTRIBUTES = %i[company description id location review_status position url].freeze

  attr_reader(*ATTRIBUTES)

  def initialize(options = {})
    ATTRIBUTES.each do |attribute|
      self.class.send(:attr_reader, attribute)
      self.class.send(:attr_writer, attribute)
      self.class.send(:private, "#{attribute}=")
    end

    options.each do |key, val|
      send("#{key}=", val)
    end

    @review_status ||= :needs_review

    @point_allocation = PointAllocation.new(description)
  end

  def points
    @point_allocation.points
  end

  def passing_score?
    @point_allocation.passing_score?
  end

  def review_status_pretty
    return '' if @review_status.nil?

    color = if bad_match?
              :red
            elsif applied?
              :blue
            elsif needs_review?
              :yellow
            elsif interested?
              :light_blue
            elsif dont_want?
              :red
            else
              ''
            end

    review_status.to_s.send(color)
  end

  def to_s
    puts "#{position} @ #{company}".colorize(background: :green, color: :black)

    puts '> Description'.colorize(background: :white, color: :black)
    puts description

    puts @point_allocation
  end

  def needs_review?
    review_status == :needs_review || review_status.nil?
  end

  def applied?
    review_status == :applied
  end

  def bad_match?
    review_status == :bad_match
  end

  def needs_review!
    self.review_status = :needs_review
  end

  def applied!
    self.review_status = :applied
  end

  def bad_match!
    self.review_status = :bad_match
  end

  def dont_want!
    self.review_status = :dont_want
  end

  def dont_want?
    self.review_status == :dont_want
  end

  def interested!
    self.review_status = :interested
  end

  def interested?
    self.review_status == :interested
  end

  def good_matches
    @point_allocation.good_matches.sort.join(', ')
  end

  private

  attr_writer :review_status
end