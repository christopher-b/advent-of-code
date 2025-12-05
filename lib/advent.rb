$LOAD_PATH.unshift(File.dirname(__FILE__))

require "debug"
require "advent/benchmark"
require "advent/cli"
require "advent/challenge"
require "advent/day_info"
require "advent/generator"

# Helper classes
require "advent/cursor"
require "advent/graph"
require "advent/grid"
require "advent/math"
require "advent/point"
require "advent/priority_queue"
require "advent/vector"

# Advent of Code solution framework.
# Provides utilities for solving, testing, and benchmarking Advent of Code challenges.
#
# @example Running a challenge
#   Advent::Challenge.run(year: 2024, day: 1)
#
# @example Getting a challenge instance
#   challenge = Advent::Challenge.get(year: 2024, day: 1)
#   challenge.part1
#
# @see https://adventofcode.com
module Advent
  # Pads a day number with a leading zero for file naming consistency.
  #
  # @param day [Integer, String] The day number (1-25)
  # @return [String] Zero-padded day string (e.g., "01", "15")
  # @example
  #   Advent.pad_day(1)   # => "01"
  #   Advent.pad_day(15)  # => "15"
  def self.pad_day(day)
    day.to_s.rjust(2, "0")
  end

  # Module containing all 2023 Advent of Code challenge implementations.
  # Classes are autoloaded on demand.
  module Year2023
    (1..25).each do |day|
      day = Advent.pad_day(day)
      autoload :"Day#{day}", "advent/year2023/day#{day}"
    end
  end

  # Module containing all 2024 Advent of Code challenge implementations.
  # Classes are autoloaded on demand.
  module Year2024
    (1..25).each do |day|
      day = Advent.pad_day(day)
      autoload :"Day#{day}", "advent/year2024/day#{day}"
    end
  end

  # Module containing all 2025 Advent of Code challenge implementations.
  # Classes are autoloaded on demand.
  module Year2025
    (1..12).each do |day|
      day = Advent.pad_day(day)
      autoload :"Day#{day}", "advent/year2025/day#{day}"
    end
  end

  # Test module for development and testing purposes.
  # @api private
  module Year2099
    class Day01 < Challenge; end
  end
end
