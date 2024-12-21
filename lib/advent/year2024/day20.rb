# https://adventofcode.com/2024/day/20
module Advent
  module Year2024
    class Day20 < Advent::Challenge
      # Explanation here

      def part1
        shortcut_count(2)
      end

      def part2
        shortcut_count(20)
      end

      # Prepopulate a grid representing the distance from the origin to each path point
      def distance_grid
        @distance_grid ||= Array.new(maze.height) { Array.new(maze.width, -1) }.tap do |distances|
          current = origin
          distances[current.y][current.x] = 0
          while current != finish
            maze.adjacent_points_in_range(current).each do |point|
              next if maze.value_at(point) == "#"
              next if distances[point.y][point.x] != -1
              distances[point.y][point.x] = distances[current.y][current.x] + 1
              current = point
            end
          end
        end
      end

      def shortcut_count(test_radius, cutoff = 100)
        count = 0
        # Iterate the whole grid
        maze.each_point do |start_point|
          next if is_wall?(start_point)

          # Find all points within 20 of the start point
          (2..test_radius).each do |radius|
            # For each radius, find all points by varying row_delta and col_delta
            (0..radius).each do |row_delta|
              col_delta = radius - row_delta
              point_in_quadrants(start_point, row_delta, col_delta).each do |end_point|
                next unless maze.in_range?(end_point)
                next if is_wall?(end_point)

                # We now have a valid shortcut. Check the distance it saves
                distance = distance_grid[end_point.y][end_point.x] - distance_grid[start_point.y][start_point.x]
                if distance >= cutoff + radius
                  count += 1
                end
              end
            end
          end
        end

        count
      end

      def point_in_quadrants(point, row_delta, col_delta)
        Set.new([
          point + Point.new(col_delta, row_delta),
          point + Point.new(col_delta, -row_delta),
          point + Point.new(-col_delta, row_delta),
          point + Point.new(-col_delta, -row_delta)
        ])
      end

      def is_wall?(point)
        maze.value_at(point) == "#"
      end

      def maze
        @maze ||= Grid.new(input_lines)
      end

      def origin
        @origin ||= maze.find_first_char("S")
      end

      def finish
        @finish ||= maze.find_first_char("E")
      end
    end
  end
end
