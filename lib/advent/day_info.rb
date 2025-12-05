module Advent
  # Value object that encapsulates information about a specific Advent of Code challenge day.
  # Provides paths and references for challenge code, tests, and input files.
  #
  # @example Creating day info and accessing paths
  #   day_info = DayInfo.new(year: 2024, day: 1)
  #   day_info.challenge_path  # => "lib/advent/year2024/day01.rb"
  #   day_info.input_path      # => "data/2024/01-input.txt"
  #
  # @!attribute [r] year
  #   @return [Integer, String] The year of the challenge
  # @!attribute [r] day
  #   @return [Integer, String] The day of the challenge (1-25)
  DayInfo = Data.define(:year, :day) do
    # Dynamically retrieves the Challenge class for this year and day.
    #
    # @return [Class] The challenge class (e.g., Advent::Year2024::Day01)
    # @raise [NameError] If the challenge class doesn't exist
    def challenge_class
      Object.const_get "Advent::Year#{year}::Day#{padded_day}"
    end

    # Opens and returns the actual input file for this challenge.
    #
    # @return [File] An open file handle for the input file
    def input
      File.open(input_path, "r")
    end

    # Opens and returns the sample input file for this challenge.
    #
    # @return [File] An open file handle for the sample input file
    def sample_input
      File.open(sample_input_path, "r")
    end

    # Returns the path to the actual input file.
    #
    # @return [String] Path in the format "data/YEAR/DD-input.txt"
    # @example
    #   DayInfo.new(year: 2024, day: 1).input_path
    #   # => "data/2024/01-input.txt"
    def input_path
      "#{input_directory}/#{padded_day}-input.txt"
    end

    # Returns the path to the sample input file.
    #
    # @return [String] Path in the format "data/YEAR/DD-sample.txt"
    # @example
    #   DayInfo.new(year: 2024, day: 1).sample_input_path
    #   # => "data/2024/01-sample.txt"
    def sample_input_path
      "#{input_directory}/#{padded_day}-sample.txt"
    end

    # Returns the directory containing challenge implementation files.
    #
    # @return [String] Path in the format "lib/advent/yearYEAR"
    # @example
    #   DayInfo.new(year: 2024, day: 1).code_directory
    #   # => "lib/advent/year2024"
    def code_directory
      "lib/advent/year#{year}"
    end

    # Returns the directory containing input files for this year.
    #
    # @return [String] Path in the format "data/YEAR"
    # @example
    #   DayInfo.new(year: 2024, day: 1).input_directory
    #   # => "data/2024"
    def input_directory
      "data/#{year}"
    end

    # Returns the directory containing test files for this year.
    #
    # @return [String] Path in the format "test/advent/yearYEAR"
    # @example
    #   DayInfo.new(year: 2024, day: 1).test_directory
    #   # => "test/advent/year2024"
    def test_directory
      "test/advent/year#{year}"
    end

    # Returns the path to the challenge implementation file.
    #
    # @return [String] Path in the format "lib/advent/yearYEAR/dayDD.rb"
    # @example
    #   DayInfo.new(year: 2024, day: 1).challenge_path
    #   # => "lib/advent/year2024/day01.rb"
    def challenge_path
      "#{code_directory}/day#{padded_day}.rb"
    end

    # Returns the path to the test file.
    #
    # @return [String] Path in the format "test/advent/yearYEAR/dayDD.test.rb"
    # @example
    #   DayInfo.new(year: 2024, day: 1).test_path
    #   # => "test/advent/year2024/day01.test.rb"
    def test_path
      "#{test_directory}/day#{padded_day}.test.rb"
    end

    # Returns the day number padded with a leading zero.
    #
    # @return [String] Two-digit day string (e.g., "01", "15", "25")
    # @example
    #   DayInfo.new(year: 2024, day: 1).padded_day  # => "01"
    #   DayInfo.new(year: 2024, day: 15).padded_day # => "15"
    def padded_day
      Advent.pad_day(day)
    end
  end
end
