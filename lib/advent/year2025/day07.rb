# https://adventofcode.com/2025/day/07
module Advent
  module Year2025
    class Day07 < Advent::Challenge
      # My first attempt was to parse the input as a directed tree graph and try to find the
      # number of nodes, and paths from root to leaves. That took way too long. This method
      # was inspired by a solution visualization:
      # https://www.reddit.com/r/adventofcode/comments/1pgbg8a/2025_day_7_part_2_visualization_for_the_sample/

      def parse_input
        @beams = Hash.new { |h, k| h[k] = 0 }
        @splitters = Set.new

        @beams[origin_x] = 1

        input_lines.each_with_index do |line, y|
          @beams.keys.each do |x|
            if line[x] == "^"
              count = @beams[x]
              @beams[x - 1] += count
              @beams[x + 1] += count
              @beams.delete(x)
              @splitters << [x, y]
            end
          end
        end
      end

      def part1
        @splitters.size
      end

      def part2
        @beams.values.sum
      end

      def origin_x = input_lines.first.index("S")
    end
  end
end
