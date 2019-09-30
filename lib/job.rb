require 'active_record'

class Job < ActiveRecord::Base
  validates :company, :description, :job_id, :location, :position,
            :review_status, :url, presence: true
end