# https://adventofcode.com/2023/day/14
module Advent
  module Year2023
    class Day14 < Advent::Challenge
      # Explanation here

      def part1
        north_grid = tilt_north(grid.dup)
        score(north_grid)
      end

      def part2
        g = grid.dup
        past_grids = []
        first_match = nil
        first_index = nil
        result = nil
        loop.with_index do |_, i|
          g = spin(g)

          # We determine where the pattern stabilizes, and on what cycle
          if (past_cycle = past_grids.index(g))
            first_match ||= past_cycle
            first_index ||= i

            if past_cycle == first_match && first_index != i
              # Now the pattern has stabilized!
              # We can derive a function that returns the original cycle for any future cycle
              cycle_len = i - first_index
              output_offset = first_match
              input_offset = first_match - ((first_index % cycle_len) + output_offset)
              # puts "((x + #{input_offset}) % #{cycle_len}) + #{output_offset}"
              # And apply that function to the 100m cycle
              result = ((999_999_999 + input_offset) % cycle_len) + output_offset
              break
            end
          end
          past_grids << g
        end
        # And compute the score for that cycle
        # puts "Result: #{result}"
        score(past_grids[result])
      end

      def grid
        @grid ||= input_lines.map { _1.chars }
      end

      def spin(grid)
        tilt_east(
          tilt_south(
            tilt_west(
              tilt_north(grid)
            )
          )
        )
      end

      def tilt_north(grid)
        grid.transpose.map { sort_forward(_1) }.transpose
      end

      def tilt_west(grid)
        grid.map { sort_forward(_1) }
      end

      def tilt_south(grid)
        grid.transpose.map { sort_backwards(_1) }.transpose
      end

      def tilt_east(grid)
        grid.map { sort_backwards(_1) }
      end

      def sort_forward(row)
        row.join("").split(/(#)/).map { _1.chars.sort.reverse }.join.chars
      end

      def sort_backwards(row)
        row.join("").split(/(#)/).map { _1.chars.sort }.join.chars
      end

      def score(grid)
        sum = 0
        grid.reverse.each_with_index do |row, i|
          count = row.select { _1 == "O" }.size
          sum += count * (i + 1)
        end
        sum
      end
    end
  end
end
