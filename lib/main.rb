require_relative 'scraper'
require_relative 'review'

class Main
  def self.start
    new
  end

  def initialize
    loop do
      action = prompt
      case action
      when 's'
        Scraper.start
      when 'r'
        Review.start
      else
        puts('Bad input, please press <enter> to continue')
        gets
      end
    end
  end

  def prompt
    print('s (scrape) | r (review): ')
    gets.chomp
  end
end

Main.start