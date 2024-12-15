# https://adventofcode.com/2024/day/14
module Advent
  module Year2024
    class Day14 < Advent::Challenge
      include Advent::Math
      # I was able to solve part 1 without brute force by taking the modulo of the velocity by
      # the number of iterations.
      #
      # I initially solved part 2 with a brute force approach by finding a low point in the
      # variance of the robots' positions. I then iterated until the variance was below at those
      # minimums for both x and y. This took about 4 seconds.
      #
      # After reading the subreddit, I learned about the Chinese Remainder Theorem. This math
      # is new to me but I was glad to be able to come up with an implementation that worked.

      attr_accessor :grid

      def part1
        positions = robot_positions_after_iterations(100)
        robots_per_quadrant(positions).reduce(:*)
      end

      def part2
        # Calculate initial variances for the first 103 steps
        x_variance = []
        y_variance = []
        [grid.x, grid.y].max.times do |i|
          positions = robot_positions_after_iterations(i)
          x_variance[i] = variance(positions.map(&:x))
          y_variance[i] = variance(positions.map(&:y))
        end

        best_x = x_variance.index(x_variance.min)
        best_y = y_variance.index(y_variance.min)

        res1 = best_x % grid.x
        res2 = best_y % grid.y

        chinese_remainder(res1, grid.x, res2, grid.y)

        # This is the naive method: iterate until both values are below the variance threshold
        # i = 0
        # loop do
        #   positions = simulate_robots(i).map(&:position)
        #   x_variance = variance(positions.map(&:x))
        #   y_variance = variance(positions.map(&:y))
        #
        #   return i if x_variance < x_min + 10 && y_variance < y_min + 10
        #   i += 1
        # end
      end

      def robot_positions_after_iterations(times)
        robots.map do |robot|
          robot.step(times).position
        end
      end

      # def render_grid
      #   puts ""
      #   grid.y.times do |y|
      #     grid.x.times do |x|
      #       robots_here = robots.select { |r| r.position == Point.new(x, y) }
      #       if robots.any? { |r| r.position == Point.new(x, y) }
      #         print robots_here.size
      #       else
      #         print "."
      #       end
      #     end
      #     puts
      #   end
      # end

      def robots_per_quadrant(positions)
        grid_h_mid = (grid.x - 1) / 2
        grid_v_mid = (grid.y - 1) / 2
        nw = positions.select { |p| p.x < grid_h_mid && p.y > grid_v_mid }
        ne = positions.select { |p| p.x > grid_h_mid && p.y > grid_v_mid }
        sw = positions.select { |p| p.x < grid_h_mid && p.y < grid_v_mid }
        se = positions.select { |p| p.x > grid_h_mid && p.y < grid_v_mid }
        [nw, ne, sw, se].map(&:size)
      end

      def parse_input
        @grid = Point.new(101, 103)
      end

      def robots
        @robots ||= input_lines.map do |line|
          parts = line.split(" ")
          origin_bits = parts[0].split(/[,=]/)
          origin = Advent::Point.new(origin_bits[1].to_i, origin_bits[2].to_i)

          direction_bits = parts[1].split(/[,=]/)
          direction = Advent::Point.new(direction_bits[1].to_i, direction_bits[2].to_i)
          Robot.new(origin, direction, grid)
        end
      end

      class Robot
        attr_reader :grid, :vector
        def initialize(position, direction, grid)
          @vector = Vector.new(position, direction)
          @grid = grid
        end

        def position
          vector.position
        end

        def step(times = 1)
          new_x = (position.x + vector.direction.x * times) % grid.x
          new_y = (position.y + vector.direction.y * times) % grid.y
          Robot.new(Point.new(new_x, new_y), vector.direction, grid)
        end
      end
    end
  end
end
