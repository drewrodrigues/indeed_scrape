require_relative 'job'
require_relative 'alert'

# responsible for pulling data from page to return job postings
class Parser
  attr_reader :browser, :driver, :wait

  def initialize(driver, browser, wait)
    @driver = driver
    @browser = browser
    @wait = wait
  end

  def parse_jobs
    jobs = []

    job_cards.each_with_index do |job_card, i|
      next if already_saved?(job_card)
      next if prime?(job_card)
      next if bad_position?(job_card)

      begin
        go_to_card(job_card, i)
        job = job_from_card(job_card)
        job.save
      rescue => e
        # TODO: fixme, figure out why this is breaking
        # puts "*" * 20
        # puts "rescued"
        # puts e
        # puts "*" * 20
      end
    end

    jobs
  end

  private

  def already_saved?(job_card)
    return nil unless Job.find_by(job_id: job_card.attribute('id'))

    Alert.already_saved
    true
  end

  def go_to_card(job_card, i)
    begin
      browser.scroll_to_card(i)
      job_card.click
    rescue Selenium::WebDriver::Error::ElementClickInterceptedError
      retry
    end

    begin
      wait.until { driver.find_element(id: 'vjs-jobtitle') }
    rescue Selenium::WebDriver::Error::TimeoutError
      Alert.timeout('Timeout occured. Job was most likely opened in a new tab.')
    end
  end

  def job_from_card(job_card)
    job = parse_job_posting(job_card)
    Alert.of_pass_or_fail_for(job)
    job
  end

  def prime?(job_card)
    downcased_text = job_card.text.downcase
    return false unless downcased_text =~ /indeed prime/ || downcased_text =~ /seen by indeed/

    Alert.prime
    true
  end

  def job_cards
    driver.find_elements(class: 'jobsearch-SerpJobCard')
  end

  def parse_job_posting(job_card)
    Job.new(pull_data_from_page(job_card))
  end

  def pull_data_from_page(job_card)
    {
      position: driver.find_element(id: 'vjs-jobtitle').text,
      company: driver.find_element(id: 'vjs-cn').text,
      location: driver.find_element(id: 'vjs-loc').text,
      description: driver.find_element(id: 'vjs-content').text,
      job_id: job_card.attribute('id'),
      url: job_card.find_element(tag_name: 'a').attribute('href')
    }
  end

  def bad_position?(job_card)
    bad_position = SETTINGS[:position_exclusions].find { |title| job_card.text.downcase.include?(title) }
    if bad_position
      Alert.bad_position(bad_position)
      true
    end
  end
end