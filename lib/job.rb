require 'active_record'
require 'colorize'
require_relative 'point_allocation'

class Job < ActiveRecord::Base
  after_initialize :set_point_allocation
  attr_reader :point_allocation

  delegate :points, :passing_score?, :good_matches, to: :point_allocation

  VALID_STATUSES = %w(needs_review applied bad_match dont_want interested response)
  enum status: VALID_STATUSES

  validates :company, :description, :job_id, :location, :position, :status,
            :url, presence: true
  validates :status, inclusion: { in: VALID_STATUSES }

  def review_status_pretty
    color = if bad_match?
              :red
            elsif applied?
              :green
            elsif needs_review?
              :yellow
            elsif interested?
              :light_blue
            elsif dont_want?
              :red
            elsif response?
              :green
            else
              ''
            end

    status.to_s.send(color)
  end

  def to_s
    puts "#{position} @ #{company}".colorize(background: :green, color: :black)

    puts '> Description'.colorize(background: :white, color: :black)
    puts description
  end

  def set_point_allocation
    @point_allocation = PointAllocation.new(description)
  end
end