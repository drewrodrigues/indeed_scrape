require "selenium-webdriver"
require "pry"
require_relative 'browser'
require_relative 'job_posting'
require_relative 'parser'
require_relative 'point_allocation'
require_relative 'storage'

# TODO: make into a config.keywords ?
PointAllocation.options(YAML.load(File.read('./config/keywords.yml')))

# pull together objects to perform their individual jobs
# in order to scrape jobs
class Scraper
  attr_reader :storage, :driver, :wait, :browser, :parser

  def self.run
    new.run
  end

  def initialize
    @storage = Storage.new
    @driver = Selenium::WebDriver.for :chrome
    @wait = Selenium::WebDriver::Wait.new(timeout: 10)
    @browser = Browser.new(driver, wait)
    @parser = Parser.new(driver, browser, storage, wait)
  end

  def run
    browser.search('Software Engineer', 'San Francisco, California')
    browser.each_page do
      jobs = parser.parse_jobs
      storage.save_jobs(jobs)
    end
  end
end
