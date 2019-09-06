require "selenium-webdriver"
require "pry"
require_relative 'browser'
require_relative 'job_posting'
require_relative 'parser'
require_relative 'point_allocation'
require_relative 'storage'

# TODO: make into a config.keyswords ?
PointAllocation.options(YAML.load(File.read('./config/keywords.yml')))

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
    @parser = Parser.new(driver, browser, storage)
  end

  def run
    browser.search('Software Engineer', 'San Francisco, California')
    jobs = parser.parse_jobs
    storage.add(jobs)
  end
end



















# email_input = driver.find_element(name: 'session_key')
# email_input.send_keys "thesimpledev@gmail.com"
#
# password_input = driver.find_element(name: 'session_password')
# password_input.send_keys "Dev4life95."
#
# submit_button = driver.find_element(class: 'sign-in-form__submit-btn')
# submit_button.click
#
# binding.pry
# # sleep(50)
# # TODO: check for captcha .recaptcha-checkbox-border
#
# # TODO: are blocks in the same scope?
# # wait.until { driver.find_element(link_text: 'Jobs') } # when this is there when captcha comes up, it breaks
# jobs_button = driver.find_element(link_text: 'Jobs')
# jobs_button.click
#
# # keywords for job
# # - wait for search bar (it's cutting off text)
# sleep(2)
# # - add text
# job_title_box = driver.find_element(class: 'jobs-search-box__input--keyword')
# job_title_input = job_title_box.find_element(tag_name: 'input')
# job_title_input.send_keys('software engineer')
#
# # location for job
# job_location_box = driver.find_element(class: 'jobs-search-box__input--location')
# job_location_input = job_location_box.find_element(tag_name: 'input')
# job_location_input.send_keys('san francisco')
#
# # search
# job_search_button = driver.find_element(class: 'jobs-search-box__submit-button')
# job_search_button.click
#
# # sort by date
# # - wait for query
# wait.until { driver.find_element(class: 'jobs-search-dropdown__trigger') }
# # - open drop down
# sort_by_dropdown = driver.find_element(class: 'jobs-search-dropdown__trigger')
# sort_by_dropdown.click
# # - click `post date`
# post_date_button = driver.find_element(class: 'jobs-search-dropdown__option-button--date')
# post_date_button.click
#
# # only quick apply
# # - open dropdown
# linkedin_features = driver.find_elements(class: 'search-s-facet__button')[1]
# linkedin_features.click
# # - select `easy apply` checkbox
# easy_apply_checkbox = driver.find_elements(class: 'search-s-facet-value')[6]
# easy_apply_checkbox.click
# # -- wait until it's done being selected
# wait.until { driver.find_element(class: 'artdeco-button--primary') }
# # - apply button
# apply_filter_button = driver.find_elements(class: 'facet-collection-list__apply-button')[1]
# apply_filter_button.click
#
# # find out how many pages we can go through
# breadcrumb_nav_links = driver.find_elements(class: 'artdeco-pagination__indicator')
# last_page_number = breadcrumb_nav_links[-1].text.to_i
#
# 1.upto(last_page_number) do |page_number|
#   # go through search result cards
#   # - wait until pane loaded
#   wait.until { driver.find_element(class: 'jobs-search-results') }
#   sleep(1)
#   # - scroll to load all 25 jobs
#   driver.execute_script('
#     let scrollable = document.querySelector(".jobs-search-results");
#     const interval = setInterval(function() {
#       console.log("run")
#       if (scrollable.scrollTop + 1000 >= scrollable.scrollHeight) {
#         console.log("Done, going back to top!")
#         // scrollable.scrollTop = 0
#         clearInterval(interval)
#       } else {
#         scrollable.scrollTop += 250
#       }
#     }, 100)
#   ')
#   # - wait until scroll is done
#   wait.until { driver.find_elements(class: 'job-card-search--two-pane').count == 25 }
#   # - iterate through each
#   jobs = driver.find_elements(class: 'job-card-search--two-pane')
#
#   jobs.each_with_index do |job, job_number|
#     # check if url already saved
#     url = driver.find_elements(class: 'job-card-search__link-wrapper')[job_number * 2].attribute('href')
#     id = job.attribute('data-job-id')
#     if storage.already_saved?(id)
#       puts "URL already saved, skipping".colorize(background: :blue, color: :white)
#       next
#     end
#
#     job.find_element(tag_name: 'img').click # clicking the element has bugs at times (sometimes clicks and goes to page)
#     sleep(1)
#
#
#     # check to see if I already applied
#     begin
#       apply_button = driver.find_element(class: 'jobs-apply-button')
#     rescue Selenium::WebDriver::Error::NoSuchElementError
#       # if not found, I already applied, go to next
#       puts 'Going to next, already applied'.colorize(background: :yellow, color: :black)
#       next
#     end
#
#     description = driver.find_element(class: 'jobs-description__content').text
#     position, company, location = job.text.split("\n")
#     posting = JobPosting.new(
#       company: company,
#       description: description,
#       id: id,
#       location: location,
#       position: position,
#       url: url
#     )
#
#     if posting.passing_score?
#       storage.save_match(posting)
#       puts "Passed, score was: #{posting.points}".colorize(background: :green, color: :white)
#     else
#       storage.save_miss(posting)
#       puts "Failed, score was: #{posting.points}".red
#     end
#   end
#
#   # go to next page
#   puts 'Going to next page'.colorize(background: :magenta, color: :white)
#   last_link = nil
#   breadcrumb_nav_links = driver.find_elements(class: 'artdeco-pagination__indicator')
#   breadcrumb_nav_links.each do |link|
#     # if next link is ...
#     if last_link && (last_link.text.to_i == page_number && link.text == '…')
#       link.click
#       break
#     elsif link.text.to_i == page_number + 1
#       link.click
#       break
#     end
#
#     last_link = link
#   end
# end
#
# driver.quit