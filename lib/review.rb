require_relative 'storage'
require 'tty-table'

class Review
  attr_reader :storage

  def initialize
    self.storage = Storage.new
    loop do
      system('clear')
      display
      id = select_id
      do_review_on(id)
      save
    end
  end

  def display
    header = ['id', 'Position', 'Company', 'Review Status', 'Points', 'Good Matches'].map { |h| h.green }
    rows = []
    storage.matches.each_with_index do |match, index|
      rows << [index, match.position, match.company, match.review_status_pretty, match.points, match.good_matches]
    end

    table = TTY::Table.new header, rows
    puts table.render(:unicode)
  end

  def select_id
    print 'Select id: '.green
    gets.chomp.to_i
  end

  def do_review_on(id)
    print '(a: applied | b: bad match | d: dont want | i: interested | n: needs review | v: view | o: open): '.red
    action = gets.chomp
    posting = storage.matches[id]

    case action
    when 'a'
      posting.applied!
    when 'c'
      # TODO: clear_dont_want_and_bad_match
    when 'o'
      # TODO: open in browser with url
    when 'b'
      posting.bad_match!
    when 'd'
      posting.dont_want!
    when 'n'
      posting.needs_review!
    when 'i'
      posting.interested!
    when 'v'
      system('clear')
      puts storage.matches[id]
      puts '[Press enter once done]'.red
      gets
    else
      puts 'Incorrect input, please press <enter> to continue'
      gets
    end
  end

  def save
    storage.save
  end

  private

  attr_writer :storage
end