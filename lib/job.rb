require 'active_record'

class Job < ActiveRecord::Base
  REVIEW_STATUSES = %w(needs_review applied bad_match dont_want interested response)

  validates :company, :description, :job_id, :location, :position,
            :review_status, :url, presence: true
  validates :review_status, inclusion: { in: REVIEW_STATUSES }
end