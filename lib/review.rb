require_relative 'storage'
require_relative 'browser'
require 'tty-table'

class Review
  attr_reader :browser, :storage

  def initialize
    self.storage = Storage.new

    loop do
      system('clear')
      display
      id = select_id
      do_review_on(id)
    end
  end

  def display
    header = ['id', 'Position', 'Company', 'Review Status', 'Points', 'Good Matches'].map { |h| h.green }
    rows = []

    sorted_by_points.each do |id, match|
      rows << [id, match.position, match.company, match.review_status_pretty, match.points, match.good_matches]
    end

    table = TTY::Table.new header, rows
    puts table.render(:unicode, width: 1000, multiline: true)
  end

  def select_id
    print 'Select id: '.green
    gets.chomp
  end

  def do_review_on(id)
    print '(a: applied | b: bad match | d: dont want | i: interested | n: needs review | v: view | o: open): '.red
    action = gets.chomp
    posting = storage.matches[id]

    case action
    when 'a'
      posting.applied!
    when 'o'
      Browser.open_url(posting.url)
    when 'b'
      posting.bad_match!
      storage.move_from_matches_to_misses(posting)
    when 'd'
      posting.dont_want!
      storage.move_from_matches_to_misses(posting)
    when 'n'
      posting.needs_review!
    when 'i'
      posting.interested!
    when 'v'
      system('clear')
      puts posting
      puts '[Press enter once done]'.red
      gets
    else
      puts 'Incorrect input, please press <enter> to continue'
      gets
    end
  end

  private

  def sorted_by_points
    storage.matches.sort_by { |_, match| -match.points }
  end

  attr_writer :storage
end