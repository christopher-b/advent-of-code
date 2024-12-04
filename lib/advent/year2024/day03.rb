# https://adventofcode.com/2024/day/03
module Advent
  module Year2024
    class Day03 < Advent::Challenge
      # We're just doing a bunch of regex matching, with a simple state machine for part 2

      def call
        puts "Part 1: #{part1}"
        puts "Part 2: #{part2}"
      end

      def part1
        calculate_multiplications(mul_matches)
      end

      def part2
        enabled = true
        # A simple state machine. Only select `mul()` matches when we're in `do` mode
        matches = more_matches.select do |match|
          case match
          when /mul/ then enabled
          when /don't/
            enabled = false
            false
          when /do/
            enabled = true
            false
          end
        end

        calculate_multiplications(matches)
      end

      # Extract the digits from mul(x,y) and sum the products
      def calculate_multiplications(matches)
        matches
          .map { |match| mul_digits(match) }
          .sum { |a, b| a * b }
      end

      # Find instances of mul(x,y)
      def mul_matches
        input_text.scan(/mul\(\d+,\d+\)/)
      end

      # Find instances of mul(x,y), do() and don't()
      def more_matches
        input_text.scan(/mul\(\d+,\d+\)|do\(\)|don't\(\)/)
      end

      # Extract the digits from mul(x,y)
      def mul_digits(mul_string)
        mul_string.scan(/\d+/).map(&:to_i)
      end
    end
  end
end
