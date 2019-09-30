require_relative '../../lib/storage'
require_relative '../../lib/job'

require 'active_record'
require 'pry'

ActiveRecord::Base.establish_connection(
    adapter: 'sqlite3',
    database: './job_search.db'
)

ActiveRecord::Schema.define do
  storage = Storage.new
  storage.matches.each do |_, job|
    Job.create!(
      company: job.company,
      description: job.description,
      location: job.location,
      job_id: job.id,
      position: job.position,
      review_status: job.review_status,
      url: job.url
    )
  end
end