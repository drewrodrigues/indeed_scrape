require 'colorize'
require_relative '../config/settings'
require_relative 'alerts/alert_debug'
require_relative 'alerts/alert_simple'

# responsible for formatting alerts based upon some conditions
class Alert
  SELECTED_ALERTER = SETTINGS[:simple_output] ? AlertSimple : AlertDebug

  class << self
    def of_pass_or_fail_for(job)
      SELECTED_ALERTER.of_pass_or_fail_for(job)
    end

    def already_saved
      SELECTED_ALERTER.already_saved
    end

    def prime
      SELECTED_ALERTER.prime
    end

    def on_page(page_number)
      SELECTED_ALERTER.on_page(page_number)
    end

    def timeout(message)
      SELECTED_ALERTER.timeout(message)
    end

    def bad_position(position)
      SELECTED_ALERTER.bad_position(position)
    end

    def start_search(position, location)
      SELECTED_ALERTER.start_search(position, location)
    end
  end
end