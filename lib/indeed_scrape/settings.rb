module IndeedScrape
  class Settings
    class << self
      def config
        yield(self)
      end

      def show
        [
          :places,
          :positions,
          :position_exclusions,
          :good_keywords,
          :bad_keywords,
          :passing_points,
          :simple_output,
          :database_name,
          :database_adapter
        ].each do |class_variable|
          puts("#{class_variable}: #{send(class_variable)}")
        end
      end

      def places=(places)
        unless places.is_a?(Array)
          raise ArgumentError.new('Places must be an Array')
        end

        @@places = places
      end

      def positions=(positions)
        unless positions.is_a?(Array)
          raise ArgumentError.new('Positions must be an Array')
        end

        @@positions = positions
      end

      def position_exclusions=(position_exclusions)
        unless positions.is_a?(Array)
          raise ArgumentError.new('Position exclusions must be an Array')
        end

        @@position_exclusions = position_exclusions
      end

      def good_keywords=(good_keywords)
        unless good_keywords.is_a?(Hash)
          raise ArgumentError.new('Good keywords must be a Hash')
        end

        @@good_keywords = good_keywords
      end

      def bad_keywords=(bad_keywords)
        unless bad_keywords.is_a?(Hash)
          raise ArgumentError.new('Bad keywords must be a Hash')
        end

        @@bad_keywords = bad_keywords
      end

      def passing_points=(passing_points)
        unless passing_points.is_a?(Integer)
          raise ArgumentError.new('Passing points must be an Integer')
        end

        @@passing_points = passing_points
      end

      def simple_output=(simple_output)
        unless simple_output == true || simple_output == false
          raise ArgumentError.new('Simple output must be a Boolean')
        end

        @@simple_output = simple_output
      end

      def places
        @@places ||= []
      end

      def positions
        @@positions ||= []
      end

      def position_exclusions
        @@position_exclusions ||= []
      end

      def good_keywords
        @@good_keywords ||= {}
      end

      def bad_keywords
        @@bad_keywords ||= {}
      end

      def passing_points
        @@passing_points ||= 0
      end

      def simple_output
        @@simple_output ||= false
      end

      def database_name
        @@database_name ||= 'indeed_scrape'
      end

      def database_adapter
        @@database_adapter ||= 'postgresql'
      end
    end
  end
end