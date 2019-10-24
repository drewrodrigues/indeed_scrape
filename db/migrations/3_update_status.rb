require 'active_record'

require_relative '../connection'
require_relative '../../lib/indeed_scrape/job'

ActiveRecord::Schema.define do
  change_table :jobs do |t|
    t.integer :status, default: 0, null: false
  end

  %w(needs_review applied bad_match dont_want interested).each do |status|
    Job.where(review_status: status).each do |job|
      job.send("#{status}!")
    end
  end
end