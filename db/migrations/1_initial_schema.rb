require 'active_record'

ActiveRecord::Base.establish_connection(
  adapter: 'sqlite3',
  database: './job_search.db'
)

ActiveRecord::Schema.define do
  create_table :jobs, force: true do |t|
    t.string :company,        null: false
    t.string :description,    null: false
    t.integer :job_id,        null: false
    t.string :location,       null: false
    t.string :position,       null: false
    t.string :review_status,  null: false
    t.string :url,            null: false
  end
end