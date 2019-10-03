require_relative '../../lib/job'
require 'active_record'

ActiveRecord::Base.establish_connection(
    adapter: 'sqlite3',
    database: './job_search.db'
)

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