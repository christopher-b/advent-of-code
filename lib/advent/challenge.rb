module Advent
  # Base class for Advent of Code challenge implementations.
  # Subclasses should implement `part1` and `part2` methods to solve each part of the challenge.
  # Optionally, subclasses can implement a `parse_input` method for input preprocessing.
  #
  # Provides a number of helper functions to parse the input, such as:
  #  - each_line
  #  - input_chunks
  #  - input_lines
  #  - input_text
  #
  # @example Implementing a challenge
  #   class Day01 < Challenge
  #     def parse_input
  #       @numbers = input_lines.map(&:to_i)
  #     end
  #
  #     def part1
  #       @numbers.sum
  #     end
  #
  #     def part2
  #       @numbers.max
  #     end
  #   end
  class Challenge
    # @return [File, StringIO] The input file or IO object for this challenge
    attr_accessor :input_file

    # Creates a new Challenge instance.
    #
    # @param input_file [File, StringIO] The input file or IO object containing challenge data
    def initialize(input_file)
      @input_file = input_file
    end

    # Executes the challenge by calling parse_input (if defined), then part1 and part2.
    #
    # @return [String] Formatted output containing results from both parts
    def call
      parse_input if respond_to?(:parse_input)
      <<~OUTPUT
        Part 1: #{part1}
        Part 2: #{part2}
      OUTPUT
    end

    # Iterates over each line in the input file.
    # The file position is rewound after iteration completes.
    #
    # @yieldparam line [String] Each line from the input file
    # @return [Enumerator] if no block is given
    # @return [self] if a block is given
    def each_line(...)
      @input_file.each_line(...)
    ensure
      @input_file.rewind
    end

    # Returns all lines from the input file as an array with trailing newlines removed.
    # The result is memoized and the file position is rewound after reading.
    #
    # @return [Array<String>] Array of chomped lines from the input file
    def input_lines
      @input_lines ||= @input_file.readlines(chomp: true)
    ensure
      @input_file.rewind
    end

    # Returns the entire input file contents as a string.
    # The file position is rewound after reading.
    #
    # @return [String] The complete input file contents
    def input_text
      @input_file.read
    ensure
      @input_file.rewind
    end

    # Returns the input split into chunks separated by double newlines.
    # Useful for challenges where input is grouped into sections.
    # The result is memoized.
    #
    # @return [Array<String>] Array of input chunks
    def input_chunks
      @input_chunks ||= input_text.split("\n\n")
    end

    class << self
      # Runs the challenge for a specific year and day using the actual input.
      #
      # @param year [Integer] The year of the challenge
      # @param day [Integer] The day of the challenge
      # @return [String] Formatted output containing results from both parts
      def run(year:, day:)
        get(year:, day:).call
      end

      # Runs the challenge for a specific year and day using the sample input.
      #
      # @param year [Integer] The year of the challenge
      # @param day [Integer] The day of the challenge
      # @return [String] Formatted output containing results from both parts
      def run_with_sample(year:, day:)
        get_with_sample(year:, day:).call
      end

      # Retrieves a challenge instance for a specific year and day with actual input.
      #
      # @param year [Integer] The year of the challenge
      # @param day [Integer] The day of the challenge
      # @return [Challenge] An instance of the appropriate challenge subclass
      def get(year:, day:)
        day_info = DayInfo.new(year:, day:)
        day_info.challenge_class.new(day_info.input)
      end

      # Retrieves a challenge instance for a specific year and day with sample input.
      #
      # @param year [Integer] The year of the challenge
      # @param day [Integer] The day of the challenge
      # @return [Challenge] An instance of the appropriate challenge subclass
      def get_with_sample(year:, day:)
        day_info = DayInfo.new(year:, day:)
        day_info.challenge_class.new(day_info.sample_input)
      end
    end
  end
end
