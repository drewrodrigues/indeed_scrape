require_relative '../lib/indeed_scrape/settings'

ActiveRecord::Base.establish_connection(
  adapter: IndeedScrape::Settings.database_adapter,
  database: IndeedScrape::Settings.database_name
)