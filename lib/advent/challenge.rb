module Advent
  class Challenge
    attr_reader :input_file

    def initialize(input_file)
      @input_file = input_file
    end

    def call
      raise NotImplementedError
    end

    def each_line(...)
      @input_file.each_line(...)
    end

    def input_lines
      @input_file.readlines(chomp: true)
    ensure
      @input_file.rewind
    end

    class << self
      def run(year:, day:)
        day_info = DayInfo.new(year:, day:)
        day_info.challenge_class.new(day_info.input).call
      end

      def run_with_sample(year: day)
        day_info = DayInfo.new(year:, day:)
        day_info.challenge_class.new(day_info.sample_input).call
      end

      def get(year:, day:)
        day_info = DayInfo.new(year:, day:)
        day_info.challenge_class.new(day_info.input)
      end

      def get_with_sample(year:, day:)
        day_info = DayInfo.new(year:, day:)
        day_info.challenge_class.new(day_info.sample_input)
      end
    end
  end
end
