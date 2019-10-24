require 'active_record'
require_relative '../connection'

ActiveRecord::Schema.define do
  create_table :jobs, force: true do |t|
    t.string :company,        null: false
    t.string :description,    null: false
    t.string :job_id,         null: false
    t.string :location,       null: false
    t.string :position,       null: false
    t.string :review_status,  null: false
    t.string :url,            null: false
  end
end