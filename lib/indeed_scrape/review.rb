# FIXME: I'm broken (relies on status)
module IndeedScrape
  class Review
    attr_reader :browser

    def self.start
      new
    end

    def initialize
      loop do
        system('clear')
        display
        id = select_id
        do_review_on(id)
      end
    end

    def display
      header = ['id', 'Position', 'Company', 'Review Status', 'Points'].map { |h| h.green }
      rows = []

      sorted_by_points.each do |job|
        rows << [job.id, job.position[0..50], job.company[0..20], job.review_status_pretty, job.points]
      end

      table = TTY::Table.new header, rows
      puts table.render(:unicode, width: 1000, multiline: true)
    end

    def select_id
      print 'Select id: '.green
      gets.chomp
    end

    def do_review_on(id)
      action = review_prompt
      posting = sorted_by_points.find {|job| job.id == id.to_i }

      case action
      when 'a'
        posting.applied!
      when 'c'
        system "echo '#{posting.url}' | pbcopy"
      when 'o'
        Browser.open_url(posting.url)
      when 'b'
        posting.bad_match!
      when 'd'
        posting.dont_want!
      when 'n'
        posting.needs_review!
      when 'i'
        posting.interested!
      when 'r'
        posting.response!
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
      @sorted_by_points ||= Job.reviewable.matches.sort_by { |job| job.points }.to_a.last(50)
    end

    def review_prompt
      print 'a: applied
      b: bad match
      c: copy url
      d: dont want
      i: interested
      n: needs review
      v: view
      r: response
      o: open
      > '.red
      gets.chomp
    end
  end
end