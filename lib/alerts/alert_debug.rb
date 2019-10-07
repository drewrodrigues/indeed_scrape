class AlertDebug
  class << self
    def of_pass_or_fail_for(job)
      if job.passing_score?
        puts("Passed, '#{job.position}' with points: #{job.points}!"
          .black
          .on_green)
      else
        puts("Failed, '#{job.position}' with points: #{job.points}.".red)
      end
    end

    def already_saved
      puts('Already saved!'.light_blue)
    end

    def prime
      puts('Is prime, skipping.'.yellow)
    end

    def on_page(number)
      puts("On page: #{number}".white.on_magenta)
    end

    def timeout(message)
      puts message.red.on_white
    end

    def bad_position(position)
      puts("Bad position (#{position}), skipping".light_blue)
    end

    def start_search(position, location)
      puts('-' * 20)
      puts("Searching: #{position} @ #{location}")
      puts('-' * 20)
    end
  end
end