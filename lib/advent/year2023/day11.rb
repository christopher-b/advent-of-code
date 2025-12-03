# https://adventofcode.com/2023/day/11
module Advent
  module Year2023
    class Day11 < Advent::Challenge
      # This gives the wrong answer, apparently? It worked at some point

      def part1
        delta_sum(1)
      end

      def part2
        delta_sum(999999)
      end

      def delta_sum(add)
        delta = 0
        @galaxies.combination(2) do |pair|
          delta += calculate_delta(pair, add)
        end

        delta
      end

      def calculate_delta(pair, add)
        a, b = pair

        x_range = [a.x, b.x].sort
        y_range = [a.y, b.y].sort

        cross_empty_cols = count_cross_empty(@empty_cols, x_range)
        cross_empty_rows = count_cross_empty(@empty_rows, y_range)

        (a.delta_x(b) + cross_empty_cols * add) + (a.delta_y(b) + cross_empty_rows * add)
      end

      def count_cross_empty(empty_set, range)
        (empty_set & (range[0]...range[1]).to_a).size
      end

      def parse_input
        @universe = each_line.map { |line| line.chars }

        @empty_rows = detect_empties(@universe)
        @empty_cols = detect_empties(@universe.transpose)

        @galaxies = []
        @universe.each_with_index do |row, y|
          @galaxies |= row
            .each_index
            .select { |x| row[x] == "#" }
            .map { |x| Point.new(x, y) }
        end
      end

      def detect_empties(matrix)
        matrix.each_index.select { |i| matrix[i].all? { |point| point == "." } }
      end

      Point = Struct.new(:x, :y) do
        def delta(other)
          delta_x(other) + delta_y(other)
        end

        def delta_x(other)
          (x - other.x).abs
        end

        def delta_y(other)
          (y - other.y).abs
        end
      end
    end
  end
end
