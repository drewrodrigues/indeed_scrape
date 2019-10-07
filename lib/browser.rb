require 'selenium-webdriver'
require_relative 'alert'

# responsible for basic browser interactions
# such as filling in fields pressing buttons and scrolling
class Browser
  attr_reader :driver, :wait

  def self.open_url(url)
    browser = new
    browser.driver.navigate.to(url)
  end

  def initialize(driver = nil, wait = nil)
    @driver = driver || Selenium::WebDriver.for(:chrome)
    @wait = wait || Selenium::WebDriver::Wait.new(timeout: 2)
  end

  def search(position, location)
    driver.navigate.to('http://indeed.com')
    fill_in_position(position)
    fill_in_location(location)
    press_search_jobs
    close_popover_if_shown
  end

  def scroll_to_card(number)
    driver.execute_script("
      let gotoY = document.querySelectorAll('.jobsearch-SerpJobCard')[#{number}].offsetTop;
      window.scrollTo(0, gotoY);
    ")
  end

  def each_page
    page_number = 1
    loop do
      Alert.on_page(page_number)
      yield
      page_number += 1
      scroll_to_bottom
      driver.find_element(link_text: 'Next »').click
      close_popover_if_shown
    end
  end

  private

  def scroll_to_bottom
    driver.execute_script(
      "window.scrollTo(0, document.querySelector('body').offsetHeight)"
    )
  end

  def fill_in_position(position)
    driver.find_element(id: 'text-input-what')
          .send_keys(position)
  end

  def fill_in_location(location)
    driver.find_element(id: 'text-input-where')
          .send_keys("\b" * 20 + location)
  end

  def press_search_jobs
    driver.action.send_keys(:enter).perform
  end

  def close_popover_if_shown
    sleep(1)
    driver.find_element(id: 'popover-close-link').click
  rescue Selenium::WebDriver::Error::NoSuchElementError
    # popup wasn't found
  end
end