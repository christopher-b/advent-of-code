# https://adventofcode.com/2025/day/03
module Advent
  module Year2025
    class Day03 < Advent::Challenge
      # We use a sliding window on the battery array to find the highest digit
      # The trick is managing the windows size and staring index

      def part1
        banks.sum(&:joltage)
      end

      def part2
        banks.sum(&:complex_joltage)
      end

      def banks
        @banks ||= each_line.map do |line|
          BatteryBank.new(line)
        end
      end

      class BatteryBank
        attr_reader :batteries

        def initialize(init)
          @batteries = init.to_s.chomp.chars.map(&:to_i)
        end

        def joltage
          # find highest digit that is not in last position
          # find highest digit behind the first
          tens = @batteries[0..-2].max
          tens_index = @batteries.index(tens)
          ones = @batteries[tens_index + 1..].max

          tens * 10 + ones
        end

        def complex_joltage(len = 12)
          bat_size = @batteries.size
          i = 0
          result = []
          while result.size < len
            # Start by creating the scan window. We start at the current index, i
            # The size of the window is determined by how many spare chars we have left.
            window_size = bat_size - i - (len - result.size)
            window = @batteries[i..i + window_size]

            max = window.max
            result << max

            # Find the adjusted index of the window's max value
            i = window.index(max) + i + 1
          end

          result.join.to_i
        end
      end
    end
  end
end
