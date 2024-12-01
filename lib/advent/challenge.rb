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

    def lines
      @input_file.readlines(chomp: true)
    ensure
      @input_file.rewind
    end

    class << self
      def get(day)
        day.challenge_class.new(day.data)
      end

      def get_with_sample(day)
        day.challenge_class.new(day.sample_data)
      end

      def run(day)
        data = day.data
        day.challenge_class.new(data).call
      end

      def run_with_sample(day)
        data = day.sample_data
        day.challenge_class.new(data).call
      end
    end
  end
end
