# https://adventofcode.com/2025/day/04
module Advent
  module Year2025
    class Day04 < Advent::Challenge
      # Leverage our Grid and Point classes.
      # Iteratively remove points from our initial grid until there are none to remove

      def part1
        rolls = grid_rolls(initial_grid)
        rolls_to_be_removed(rolls).size
      end

      def part2
        removed_count = 0

        rolls = grid_rolls(initial_grid)
        loop do
          to_remove = rolls_to_be_removed(rolls)
          break if to_remove.empty?

          removed_count += to_remove.size
          rolls -= to_remove
        end

        removed_count
      end

      def initial_grid
        @grid ||= Grid.new(input_lines)
      end

      def grid_rolls(grid)
        grid.each_point.filter_map { |point, char| point if char == "@" }.to_set
      end

      def rolls_to_be_removed(rolls)
        rolls.filter_map do |roll|
          neighbors = roll.cardinal_neighbors + roll.diagonal_neighbors
          neighbor_count = neighbors.count do |neighbour|
            rolls.include? neighbour
          end

          # Return if it has fewer than 4 "@" neighbors
          roll if neighbor_count < 4
        end
      end
    end
  end
end
