require 'selenium-webdriver'
require 'pry'
require_relative 'browser'
require_relative 'job_posting'
require_relative 'parser'
require_relative 'point_allocation'
require_relative 'storage'
require_relative '../config/settings'

# pull together objects to perform their individual jobs
# in order to scrape jobs
class Scraper
  attr_reader :storage, :driver, :wait, :browser, :parser

  def self.start
    new.run
  end

  def initialize
    @storage = Storage.new
    @driver = Selenium::WebDriver.for :chrome
    @wait = Selenium::WebDriver::Wait.new(timeout: 2)
    @browser = Browser.new(driver, wait)
    @parser = Parser.new(driver, browser, storage, wait)
  end

  def run
    system 'clear'
    SETTINGS[:places].shuffle.each do |location|
      SETTINGS[:positions].shuffle.each do |position|
        begin
          Alert.start_search(position, location)
          browser.search(position, location)
          browser.each_page do
            jobs = parser.parse_jobs
            storage.save_jobs(jobs)
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
