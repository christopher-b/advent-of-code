# https://adventofcode.com/2024/day/06
module Advent
  module Year2024
    class Day06 < Advent::Challenge
      # Part 1 walks the path while maintaining a set of visited positions
      # Part 2 walks the path using Floyd's Tortoise and Hare algorithm to detect loops
      # Part 2 is brute-forced by adding extra obstacles along the initial walking path
      # https://www.geeksforgeeks.org/floyds-cycle-finding-algorithm/

      class LoopException < StandardError; end

      def part1
        initial_path.uniq(&:position).size
      end

      def part2
        # Brute force: add extra obstacles along the initial path
        initial_path.uniq(&:position).count do |start_vector|
          walk_with_loop_detection(start_vector)
        end
      end

      def walk
        Set.new([origin]).tap do |visited|
          cursor = Guard.new(origin)
          while valid_position?(cursor.next_position)
            if is_obstacle?(cursor.next_position)
              cursor.rotate
            else
              cursor.step
            end

            visited << cursor.vector
          end
        end
      end

      def walk_with_loop_detection(new_origin)
        Set.new([new_origin]).tap do |visited|
          # pp "Checking loop for #{new_origin}"
          cursor = Guard.new(new_origin)
          extra_obstacle = cursor.next_position

          # Early exit if the cursor is already pointing to an obstacle
          return false if valid_position?(cursor.next_position) && is_obstacle?(cursor.next_position)

          while valid_position?(cursor.next_position)
            # puts cursor.vector
            if is_obstacle?(cursor.next_position, extra_obstacle)
              cursor.rotate
            else
              cursor.step
            end

            if visited.include?(cursor.vector)
              # puts "LOOP"
              return true
            end
            visited << cursor.vector
          end
        end

        # puts "NO LOOP"
        false
      end

      # Tortoise moves one step, hare moves two steps
      #   tortoise = Cursor.new(new_origin)
      #   hare = Cursor.new(new_origin)
      #   extra_obstacle = tortoise.next_position
      #
      #   puts "Planting obstacle at #{tortoise.next_position}"
      #
      #   while valid_position?(hare.next_position) # Hare jumps out of the map first
      #     # Move tortoise one step
      #     is_obstacle?(tortoise.next_position, extra_obstacle) ? tortoise.rotate : tortoise.step
      #
      #     # Move hare two steps
      #     2.times do
      #       if valid_position?(hare.next_position)
      #         is_obstacle?(hare.next_position, extra_obstacle) ? hare.rotate : hare.step
      #       end
      #     end
      #
      #     # Check if tortoise and hare meet
      #     if tortoise.position == hare.position && tortoise.direction == hare.direction
      #       raise LoopException, "Loop detected at #{tortoise.position} with direction #{tortoise.direction}"
      #     end
      #   end
      #   false
      # rescue LoopException
      #   true

      def initial_path
        @initial_path ||= walk
      end

      def valid_position?(position)
        @x_range ||= (0...grid.first.size)
        @y_range ||= (0...grid.size)
        position.x_in_range?(@x_range) && position.y_in_range?(@y_range)
      end

      def is_obstacle?(position, extra_obstacle = nil)
        extra_obstacle == position || value_at(position) == "#"
      end

      def value_at(position)
        grid[position.y][position.x]
      end

      def grid
        @grid ||= input_lines.map { |line| line.chars }
      end

      def origin
        @origin ||= grid.each_with_index do |row, x|
          if (y = row.index("^"))
            return Vector.new(Point.new(y, x), UP)
          end
        end
      end

      UP = Point.new(0, -1)
      DOWN = Point.new(0, 1)
      LEFT = Point.new(-1, 0)
      RIGHT = Point.new(1, 0)

      class Guard < Cursor
        def rotate
          @vector = Vector.new(position, next_direction)
        end

        def next_direction
          case direction
          when UP then RIGHT
          when RIGHT then DOWN
          when DOWN then LEFT
          when LEFT then UP
          end
        end
      end
    end
  end
end
