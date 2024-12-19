# https://adventofcode.com/2024/day/19
module Advent
  module Year2024
    class Day19 < Advent::Challenge
      # Another fairly straightforward one.
      # We can use a recursive function to check all possible designs, reducing the string by one each time

      def part1
        design_counts.count { |count| count > 0 }
      end

      def part2
        design_counts.sum
      end

      def design_counts
        @design_cache ||= {}
        @design_counts ||= designs.map { |design| design_possible(design) }
      end

      def design_possible(design)
        @design_cache[design] ||= if design.empty?
          1
        else
          towels.select { |t| design.start_with?(t) }.reduce(0) do |count, towel|
            count + design_possible(design[towel.size..])
          end
        end
      end

      def designs
        @designs ||= input_chunks[1].lines.map(&:chomp)
      end

      def towels
        @towels ||= input_chunks[0].split(", ").sort_by(&:size).reverse
      end
    end
  end
end
