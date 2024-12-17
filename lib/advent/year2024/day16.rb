# https://adventofcode.com/2024/day/16
module Advent
  module Year2024
    class Day16 < Advent::Challenge
      # Explanation here

      def part1
        dijkstra_walk
      end

      def part2
      end

      def dijkstra_walk
        queue = PriorityQueue.new
        queue << Node.new(0, origin)
        seen = Set.new([origin])

        until queue.empty?
          node = queue.pop
          current = node.vector
          cost = node.cost
          seen.add(current)

          return cost if current.position == finish

          # Three possible moves: forward, turn left, turn right
          next_positions = [
            [cost + 1, current.step],
            [cost + 1000, current.rotate_clockwise],
            [cost + 1000, current.rotate_counter_clockwise]
          ]
          next_positions.each do |new_cost, next_vector|
            next if walls[next_vector.position]
            next if seen.include?(next_vector)
            queue << Node.new(cost: new_cost, vector: next_vector)
          end
        end
      end

      Node = Data.define(:cost, :vector) do
        include Comparable
        def <=>(other) = other.cost <=> cost
      end

      def origin
        @origin ||= grid.each_char
          .find { |char, x, y| char == "S" }
          .then { |_, x, y| Vector.new(Point.new(x, y), Point::E) }
      end

      def finish
        @finish ||= grid.each_char
          .find { |char, x, y| char == "E" }
          .then { |_, x, y| Point.new(x, y) }
      end

      def walls
        @walls ||= grid.each_char
          .select { |char, _, _| char == "#" }
          .map { |_, x, y| wall = Point.new(x, y), [wall, wall] }
          .to_h
      end

      def grid
        @grid ||= Grid.new(input_lines)
      end
    end
  end
end
