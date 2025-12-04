# https://adventofcode.com/2025/day/02
module Advent
  module Year2025
    class Day02 < Advent::Challenge
      # We use a string rotation trick to quickly determine if a string is periodic.
      # This filters candidates for part 1 to speed it up.

      def part1
        invalid_ids.sum
      end

      def part2
        periodic_ids.sum
      end

      def periodic_ids
        [].tap do |periodic|
          ranges.each do |range|
            range.each do |value|
              periodic << value if is_periodic?(value.to_s)
            end
          end
        end
      end

      def invalid_ids
        [].tap do |invalid|
          periodic_ids.each do |id|
            value_string = id.to_s
            len = value_string.size
            next unless len.even?
            first, second = value_string.chars.each_slice(len / 2).map(&:join)

            invalid << id if first == second
          end
        end
      end

      def is_periodic?(s)
        return false if s.empty?
        # If s is periodic, then s appears in s+s (excluding trivial match)
        # abcabc -> abcabcabcabc -> bcabcabcab
        #                             ~~~~~~
        (s + s)[1...-1].include?(s)
      end

      def ranges
        @ranges ||= input_lines.first.split(",").map do |range_string|
          start, stop = range_string.split("-")
          (start.to_i..stop.to_i)
        end
      end
    end
  end
end
