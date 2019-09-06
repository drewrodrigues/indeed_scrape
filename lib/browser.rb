require 'selenium-webdriver'
require_relative 'alert'

# responsible for basic browser interactions
# such as filling in fields pressing buttons and scrolling
class Browser
  attr_reader :driver, :wait

  def initialize(driver, wait)
    @driver = driver
    @wait = wait
  end

  def search(position, location)
    driver.navigate.to('http://indeed.com')
    fill_in_position(position)
    fill_in_location(location)
    press_search_jobs
    close_popover_if_shown
  end

  def scroll_to_card(number)
    driver.execute_script "window.scrollTo(0, #{number * 200})"
  end

  def up_to_page(number = 100)
    number.times do
      yield
      Alert.next_page
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
    puts "Popup wasn't found, great!"
  end
end