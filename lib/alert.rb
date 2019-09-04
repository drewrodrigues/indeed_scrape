require 'colorize'

# responsible for formatting alerts based upon some conditions
class Alert
  def self.of_pass_of_fail_for(job)
    if job.passing_score?
      puts "Passed, with points: #{job.points}!".green
    else
      puts "Failed, with points: #{job.points}.".red
    end
  end
end