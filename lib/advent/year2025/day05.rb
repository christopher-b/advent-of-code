# https://adventofcode.com/2025/day/05
module Advent
  module Year2025
    class Day05 < Advent::Challenge
      # My naive attempt was adding each item in each range to a set. This took way too long.
      # Instead, we comapct all overlapping ranges, then sum their size.

      def part1
        available.count { |id| is_fresh?(id) }
      end

      def part2
        compact_ranges(fresh_ranges).sum(&:size)
      end

      def is_fresh?(id)
        fresh_ranges.any? { |range| range.include? id }
      end

      def compact_ranges(ranges)
        sorted = ranges.sort_by(&:begin)

        [sorted.first].tap do |result|
          sorted[1..].each do |range|
            last = result.last

            # Check if current range overlaps or is adjacent to last range
            if range.begin <= last.end + 1
              # Merge by extending the end if necessary
              result[-1] = (last.begin..[last.end, range.end].max)
            else
              # No overlap, add as new range
              result << range
            end
          end
        end
      end

      def fresh_ranges
        @fresh_ranges ||= input_chunks.first.each_line.map do |line|
          start, stop = line.split("-").map(&:to_i)
          (start..stop)
        end
      end

      def available
        @available ||= input_chunks.last.each_line.map(&:to_i)
      end
    end
  end
end
