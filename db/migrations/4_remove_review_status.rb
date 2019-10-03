require_relative '../../lib/job'
require 'active_record'

ActiveRecord::Base.establish_connection(
    adapter: 'sqlite3',
    database: './job_search.db'
)

ActiveRecord::Schema.define do
  remove_column :jobs, :review_status, :string, null: false
end