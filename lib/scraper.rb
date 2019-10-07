require 'selenium-webdriver'
require 'pry'
require 'active_record'
require_relative 'browser'
require_relative 'job'
require_relative 'parser'
require_relative 'point_allocation'
require_relative '../config/settings'

ActiveRecord::Base.establish_connection(
  adapter: 'sqlite3',
  database: './job_search.db'
)

# pull together objects to perform their individual jobs
# in order to scrape jobs
class Scraper
  attr_reader :driver, :wait, :browser, :parser

  def self.start
    new.run
  end

  def initialize
    @driver = Selenium::WebDriver.for(:chrome)
    @wait = Selenium::WebDriver::Wait.new(timeout: 1)
    @browser = Browser.new(driver, wait)
    @parser = Parser.new(driver, browser, wait)
  end

  def run
    system('clear')
    SETTINGS[:places].shuffle.each do |location|
      SETTINGS[:positions].shuffle.each do |position|
        begin
          Alert.start_search(position, location)
          browser.search(position, location)
          browser.each_page do
            parser.parse_jobs
          end
        rescue => e
          puts '-' * 20
          puts 'Done with search or an error occurred.'
          puts e
          puts '-' * 20
        end
      end
    end
  end
end
