require 'colorize'

# responsible for formatting alerts based upon some conditions
class Alert
  def self.of_pass_of_fail_for(job)
    if job.passing_score?
      puts "Passed, '#{job.position}' with points: #{job.points}!"
        .black
        .on_green
    else
      puts "Failed, '#{job.position}' with points: #{job.points}.".red
    end
  end

  def self.already_saved
    puts 'Already saved!'.light_blue
  end

  def self.prime
    puts 'Is prime, skipping.'.yellow
  end

  def self.next_page
    puts 'Going to next page!'.white.on_magenta
  end
end