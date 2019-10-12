require_relative '../../lib/job'
require 'active_record'

ActiveRecord::Base.establish_connection(
  adapter: 'postgresql',
  database: 'better_jobs'
)

ActiveRecord::Schema.define do
  remove_column :jobs, :review_status, :string, null: false
end