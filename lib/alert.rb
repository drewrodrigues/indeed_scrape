require 'colorize'
require_relative '../config/settings'

# TODO: use decorator design pattern to do a simple & debugging alerts

# responsible for formatting alerts based upon some conditions
class Alert
  def self.of_pass_of_fail_for(job)
    if job.passing_score?
      if SETTINGS[:simple_output]
        print ' √ '.green
      else
        puts "Passed, '#{job.position}' with points: #{job.points}!"
          .black
          .on_green
      end
    else
      if SETTINGS[:simple_output]
        print ' X '.red
      else
        puts "Failed, '#{job.position}' with points: #{job.points}.".red
      end
    end
  end

  def self.already_saved
    if SETTINGS[:simple_output]
      print ' → '
    else
      puts 'Already saved!'.light_blue
    end
  end

  def self.prime
    if SETTINGS[:simple_output]
      print ' → '
    else
      puts 'Is prime, skipping.'.yellow
    end
  end

  def self.on_page(page_number)
    if SETTINGS[:simple_output]
      print "\nPage: #{page_number} ".magenta
    else
      puts "On page: #{page_number}".white.on_magenta
    end
  end

  def self.timeout(message)
    if SETTINGS[:simple_output]
      print ' X '.red.on_white
    else
      puts message.red.on_white
    end
  end

  def self.bad_position(position)
    if SETTINGS[:simple_output]
      print ' → '
    else
      puts "Bad position (#{position}), skipping".light_blue
    end
  end

  def self.start_search(position, location)
    if SETTINGS[:simple_output]
      puts "Searching #{position} @ #{location} ".magenta
    else
      puts '-' * 20
      puts "Searching: #{position} @ #{location}"
      puts '-' * 20
    end
  end
end