require 'active_record'
require 'colorize'
require 'selenium-webdriver'
require 'tty-table'

module IndeedScrape
  require_relative '../db/connection'
  require_relative 'indeed_scrape/settings'
  require_relative 'indeed_scrape/alerts/alert_debug'
  require_relative 'indeed_scrape/alerts/alert_simple'
  require_relative 'indeed_scrape/alert'
  require_relative 'indeed_scrape/browser'
  require_relative 'indeed_scrape/job'
  require_relative 'indeed_scrape/main'
  require_relative 'indeed_scrape/parser'
  require_relative 'indeed_scrape/point_allocation'
  require_relative 'indeed_scrape/review'
  require_relative 'indeed_scrape/scraper'
end