require 'active_record'

require_relative '../connection'
require_relative '../../lib/indeed_scrape/job'

ActiveRecord::Schema.define do
  remove_column :jobs, :review_status, :string, null: false
end