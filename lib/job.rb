require 'active_record'

class Job < ActiveRecord::Base
  VALID_STATUSES = %w(needs_review applied bad_match dont_want interested response)
  enum status: VALID_STATUSES

  validates :company, :description, :job_id, :location, :position,
            :review_status, :url, presence: true
  validates :status, inclusion: { in: VALID_STATUSES }
end