# https://adventofcode.com/2024/day/20
module Advent
  module Year2024
    class Day20 < Advent::Challenge
      # Explanation here

      def part1
        shortcut_count
      end

      def part2
        # 2203962 too high
        # Not 1101981
        shortcut_count_big_cheats
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

      def shortcut_count_big_cheats(cutoff = 100)
        @shortcut_count_big_cheats ||= begin
          count = 0
          # Iterate the whole grid
          maze.each_point do |start_point, char|
            next if char == "#"

            # Find all points within 20 of the start point
            (2..20).each do |radius|
              # For each radius, find all points by varying diff_row and diff_col
              (0..radius).each do |diff_row|
                diff_col = radius - diff_row
                # Fid this point in all four quadrants around the start point
                options = Set.new([
                  start_point + Point.new(diff_col, diff_row),
                  start_point + Point.new(diff_col, -diff_row),
                  start_point + Point.new(-diff_col, diff_row),
                  start_point + Point.new(-diff_col, -diff_row)
                ])
                options.each do |end_point|
                  next unless maze.in_range?(end_point)
                  next if maze.value_at(end_point) == "#"
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
      end

      def shortcut_count(cutoff = 100)
        @shortcut_count ||= begin
          count = 0
          # Iterate the whole grid
          maze.each_point do |start_point, char|
            next if char == "#"

            # Check the tile two spaces over
            [
              start_point + Point.new(2, 0),
              start_point + Point.new(0, 2),
            ].each do |end_point|
              next unless maze.in_range?(end_point)
              next if maze.value_at(end_point) == "#"

              distance = distance_grid[end_point.y][end_point.x] - distance_grid[start_point.y][start_point.x]
              if distance.abs >= cutoff + 2
                count += 1
              end
            end
          end

          count
        end
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
