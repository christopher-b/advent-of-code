# https://adventofcode.com/2024/day/06
module Advent
  module Year2024
    class Day06 < Advent::Challenge
      # Part 1 walks the path while maintaining a set of visited positions
      # Part 2 walks the path using Floyd's Tortoise and Hare algorithm to detect loops
      # Part 2 is brute-forced by adding extra obstacles along the initial walking path

      class LoopException < StandardError; end

      def part1
        initial_path.size
      end

      def part2
        # Brute force: add extra obstacles along the initial path
        initial_path.count do |step|
          walk_with_loop_detection(step)
        end
      end

      def walk
        Set.new.tap do |visited|
          visited << origin
          cursor = Cursor.new(origin)
          while valid_position?(cursor.next_position)
            if is_obstacle?(cursor.next_position)
              cursor.rotate
            else
              cursor.step
              visited << cursor.position
            end
          end
        end
      end

      def walk_with_loop_detection(extra_obstacle = Point.new(-1, -1))
        # Tortoise moves one step, hare moves two steps
        tortoise = Cursor.new(origin)
        hare = Cursor.new(origin)

        while valid_position?(hare.next_position)
          # Move tortoise one step
          is_obstacle?(tortoise.next_position, extra_obstacle) ? tortoise.rotate : tortoise.step

          # Move hare two steps
          2.times do
            if valid_position?(hare.next_position)
              is_obstacle?(hare.next_position, extra_obstacle) ? hare.rotate : hare.step
            end
          end

          # Check if tortoise and hare meet
          if tortoise.position == hare.position && tortoise.direction == hare.direction
            raise LoopException, "Loop detected at #{tortoise.position} with direction #{tortoise.direction}"
          end
        end
        false
      rescue LoopException
        true
      end

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
            return Point.new(y, x)
          end
        end
      end

      Point = Data.define(:x, :y) do
        def +(other)
          Point.new(x + other.x, y + other.y)
        end

        def x_in_range?(range)
          range.cover?(x)
        end

        def y_in_range?(range)
          range.cover?(y)
        end
      end

      UP = Point.new(0, -1)
      DOWN = Point.new(0, 1)
      LEFT = Point.new(-1, 0)
      RIGHT = Point.new(1, 0)

      class Cursor
        attr_reader :position, :direction
        def initialize(position, direction = UP)
          @position = position
          @direction = direction
        end

        def rotate
          @direction = position_iterator.next
        end

        def step
          @position = next_position
        end

        def next_position
          position + direction
        end

        def position_iterator
          @position_iterator ||= [RIGHT, DOWN, LEFT, UP].cycle
        end
      end
    end
  end
end
