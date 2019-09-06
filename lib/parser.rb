require_relative 'job_posting'
require_relative 'alert'

# responsible for pulling data from page to return job postings
class Parser
  attr_reader :browser, :driver, :storage

  def initialize(driver, browser, storage)
    @driver = driver
    @browser = browser
    @storage = storage
  end

  def parse_jobs
    jobs = []

    job_cards.each_with_index do |job_card, i|
      next if already_saved?(job_card)

      go_to_card(job_card, i)
      job = job_from_card(job_card)
      jobs << job if job
    end

    jobs
  end

  private

  def already_saved?(job_card)
    return nil unless storage.already_saved?(job_card)

    Alert.already_saved
    true
  end

  def go_to_card(job_card, i)
    browser.scroll_to_card(i)
    job_card.click
    sleep(1)
  end

  def job_from_card(job_card)
    job = parse_job_posting(job_card)
    Alert.of_pass_of_fail_for(job)
    job
  rescue Selenium::WebDriver::Error::NoSuchElementError
    Alert.prime
    nil
  end

  def job_cards
    driver.find_elements(class: 'jobsearch-SerpJobCard')
  end

  def parse_job_posting(job_card)
    JobPosting.new(pull_data_from_page(job_card))
  end

  def pull_data_from_page(job_card)
    {
      position: driver.find_element(id: 'vjs-jobtitle').text,
      company: driver.find_element(id: 'vjs-cn').text,
      location: driver.find_element(id: 'vjs-loc').text,
      description: driver.find_element(id: 'vjs-content').text,
      id: job_card.attribute('id')
    }
  end
end