# https://adventofcode.com/2024/day/06
module Advent
  module Year2024
    class Day06 < Advent::Challenge
      # Part 1 walks the path while maintaining a set of visited positions
      # Part 2 is brute-forced by adding extra obstacles along the initial walking path
      #
      # I also tried Part 2 using Floyd's Tortoise and Hare algorithm to detect loops.
      # https://www.geeksforgeeks.org/floyds-cycle-finding-algorithm/

      class LoopException < StandardError; end

      # Initial path is the set of all visited positions and directions, so we check for uniqueness by position
      def part1
        initial_path.uniq(&:position).size
      end

      # Brute force: add extra obstacles along the initial path
      def part2
        # Keep track of tried obstacle positions, because we can hit the same obstacle from different directions
        tried_obstacle_positions = Set.new

        # Count the number of loops. Start the guard further along the path
        initial_path.count do |start_vector|
          guard = Guard.new(start_vector, map)
          obstacle_position = guard.next_position

          if tried_obstacle_positions.include?(obstacle_position)
            false
          elsif !guard.facing_edge? && guard.facing_obstacle?
            # Skip if we're already facing an obstacle
            false
          else
            guard.extra_obstacle = obstacle_position
            tried_obstacle_positions << obstacle_position
            is_loop?(start_vector, guard)
          end
        end
      end

      def is_loop?(start_vector, guard)
        begin
          guard.walk_path
        rescue LoopException => _e
          return true
        end

        false
      end

      # Starting at origin, add all visited positions and direction to a set
      # Returns a list of all positions AND directions visited
      def initial_path
        @initial_path = Guard.new(origin, map)
          .walk_path
          .visited
      end

      def map
        @map ||= Grid.new(input_lines)
      end

      def origin
        @origin ||= map.each_with_index do |row, x|
          if (y = row.index("^"))
            return Vector.new(Point.new(y, x), Guard::UP)
          end
        end
      end

      class Guard < Cursor
        attr_reader :map, :visited
        attr_accessor :extra_obstacle

        UP = Point.new(0, -1)
        DOWN = Point.new(0, 1)
        LEFT = Point.new(-1, 0)
        RIGHT = Point.new(1, 0)

        def initialize(origin, map = nil)
          @map = map
          @visited = Set.new [origin]
          super(origin)
        end

        def facing_obstacle?
          map.value_at(next_position) == "#" || extra_obstacle == next_position
        end

        def facing_edge?
          !map.in_range?(next_position)
        end

        def walk_path
          until facing_edge?
            tick
          end
          self
        end

        def tick
          if facing_obstacle?
            rotate
          else
            step
          end

          raise LoopException if visited.include?(vector)
          visited << vector
        end

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
