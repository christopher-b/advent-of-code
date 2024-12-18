# https://adventofcode.com/2024/day/18
module Advent
  module Year2024
    class Day18 < Advent::Challenge
      # This solution reused the Dijsktra's walk from Day 16.
      # Part 2 is a simple binary search. I'm glad I could get this one without help.

      # Sample:
      # GRID_MAX = 6
      # SAMPLE = 12

      # Input:
      GRID_MAX = 70
      SAMPLE = 1024

      def part1
        corrupted = Set.new(bytes[...SAMPLE])
        walk(corrupted)
      end

      def part2
        # Let's to a binary search
        search_min = SAMPLE # We know we have a path with this many bytes
        search_max = bytes.size - 1 # This is smaller than the maximum number of bytes that still leaves a path
        first_nil = nil

        while search_min < search_max
          mid = (search_min + search_max) / 2
          corrupted = Set.new(bytes[..mid + 1])

          if walk(corrupted).nil?
            first_nil = mid
            search_max = mid
          else
            search_min = mid + 1
          end
        end

        bad_byte = bytes[first_nil + 1]
        "#{bad_byte.x},#{bad_byte.y}"
      end

      # Should abstract this?
      Node = Data.define(:cost, :point) do
        include Comparable
        def <=>(other) = other.cost <=> cost
      end

      def walk(corrupted)
        costs = Hash.new(Float::INFINITY)
        queue = PriorityQueue.new([Node.new(cost: 0, point: origin)])

        until queue.empty?
          queue.pop => {point:, cost:}

          next if cost > costs[point]
          return cost if point == finish

          point.cardinal_neighbors.each do |next_point|
            next unless next_point.x_in_range?(0..GRID_MAX)
            next unless next_point.y_in_range?(0..GRID_MAX)
            next if corrupted.include?(next_point)

            new_cost = cost + 1
            if new_cost < costs[next_point]
              costs[next_point] = new_cost
              queue << Node.new(cost: new_cost, point: next_point)
            end
          end
        end

        nil
      end

      def origin
        @origin ||= Point.new(0, 0)
      end

      def finish
        @finish ||= Point.new(GRID_MAX, GRID_MAX)
      end

      def bytes
        @bytes ||= input_lines.map do |line|
          x, y = line.split(",").map(&:to_i)
          Point.new(x, y)
        end
      end
    end
  end
end
