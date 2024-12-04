# https://adventofcode.com/2024/day/2
module Advent
  module Year2024
    class Day02 < Advent::Challenge
      # To check if levels are safe, we generate a list of differences between levels.
      # If all differences have the same polarity in range, it's safe.
      # For part 2, we brute force it by removing one level at a time.

      def call
        puts "Part 1: #{part1}"
        puts "Part 2: #{part2}"
      end

      def part1
        reports.count(&:safe?)
      end

      def part2
        reports.count(&:safe_with_dampener?)
      end

      def reports
        @reports ||= input_lines.map do |line|
          Report.new(line)
        end
      end

      class Report
        attr_reader :levels
        def initialize(line)
          @levels = line.split.map(&:to_i)
        end

        # Levels are safe if
        # - All increasing or all decreasing
        # - Difference between levels is 1, 2, or 3
        def safe_differences?(test_levels)
          # Compare each level to the next
          diffs = test_levels.each_cons(2).map { |a, b| a - b }
          diffs.all? { |diff| (1..3) === diff } || diffs.all? { |diff| (-3..-1) === diff }
        end

        def safe?
          safe_differences?(levels)
        end

        def safe_with_dampener?
          return true if safe?

          # Brute force it
          # Generate all possible combinations of levels with one level removed
          levels.each_with_index.any? do |_, index|
            new_levels = levels.dup
            new_levels.delete_at(index)
            safe_differences?(new_levels)
          end
        end
      end
    end
  end
end
