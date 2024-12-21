# https://adventofcode.com/2024/day/20
module Advent
  module Year2024
    class Day20 < Advent::Challenge
      # Explanation here

      def part1
        shortcut_times.select { |time| time >= 100 }.size
      end

      def part2
      end

      def path
        @path ||= [].tap do |steps|
          current_position = origin
          steps << current_position

          while current_position != finish
            next_steps = maze.adjacent_points_in_range(current_position)
            next_steps.each do |next_step|
              value = maze.value_at(next_step)
              next if value == "#" || steps.include?(next_step)

              steps << next_step
              current_position = next_step
            end
          end
        end
      end

      def shortcut_times
        @shortcut_times ||= shortcuts.map do |wall, steps|
          # Find the distance between steps
          path.find_index(steps.last) - path.find_index(steps.first) - 2
        end
      end

      def shortcuts
        @shortcuts ||= Hash.new { |h, k| h[k] = [] }.tap do |shortcuts|
          path.each do |step|
            adjacent_walls = maze
              .adjacent_points_in_range(step)
              .select { |point| maze.value_at(point) == "#" }

            adjacent_walls.each do |wall|
              shortcuts[wall] << step
            end
          end

          shortcuts.each do |wall, steps|
            # Remove steps that are not in a straight line
            x_groups = steps.group_by(&:x)
            y_groups = steps.group_by(&:y)
            steps.delete_if { |step| x_groups[step.x].size == 1 && y_groups[step.y].size == 1 }
          end
          shortcuts.delete_if { |wall, steps| steps.size < 2 }
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
