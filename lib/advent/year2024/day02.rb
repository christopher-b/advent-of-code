# https://adventofcode.com/2024/day/2
module Advent
  module Year2024
    class Day02 < Advent::Challenge
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
          @levels = line.split(" ").map(&:to_i)
        end

        def safe_differences?(levels)
          diffs = levels.each_cons(2).map { |a, b| a - b }
          diffs.all? { |diff| diff.between?(1, 3) } || diffs.all? { |diff| diff.between?(-3, -1) }
        end

        def safe?
          safe_differences?(levels)
        end

        def safe_with_dampener?
          # Brute force it
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
