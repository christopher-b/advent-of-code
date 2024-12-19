# https://adventofcode.com/2024/day/19
module Advent
  module Year2024
    class Day19 < Advent::Challenge
      # Another fairly straightforward one.
      # We can use a recursive function to check all possible designs, reducing the string by one each time

      def initialize(...)
        super
        @design_cache = {}
      end

      def part1
        design_counts.count { |count| count > 0 }
      end

      def part2
        design_counts.sum
      end

      def design_counts
        @design_counts ||= designs.map { |design| design_possible?(design) }
      end

      def design_possible?(design)
        return @design_cache[design] if @design_cache.has_key?(design)

        if design.empty?
          @design_cache[design] = 1
          return 1
        end

        count = 0

        (design.size + 1).times do |i|
          prefix, suffix = design[...i], design[i..]

          if towels.include?(prefix)
            count += design_possible?(suffix)
          end
        end

        @design_cache[design] = count
        count
      end

      def designs
        @designs ||= input_chunks[1].lines.map(&:chomp)
      end

      def towels
        @towels ||= input_chunks[0].split(", ")
      end
    end
  end
end
