# https://adventofcode.com/2024/day/03
module Advent
  module Year2024
    class Day03 < Advent::Challenge
      def call
        puts "Part 1: #{part1}"
        puts "Part 2: #{part2}"
      end

      def part1
        calculate_multiplications(mul_matches)
      end

      def part2
        enabled = true
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

      def calculate_multiplications(matches)
        matches
          .map { |match| mul_digits(match) }
          .map { |a, b| a * b }
          .sum
      end

      def mul_matches
        input_text.scan(/mul\(\d+,\d+\)/)
      end

      def more_matches
        input_text.scan(/mul\(\d+,\d+\)|do\(\)|don't\(\)/)
      end

      def mul_digits(mul_string)
        mul_string.scan(/\d+/).map(&:to_i)
      end
    end
  end
end
