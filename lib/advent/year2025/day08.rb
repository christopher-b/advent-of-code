# https://adventofcode.com/2025/day/08
module Advent
  module Year2025
    class Day08 < Advent::Challenge
      # Once again, a graph turned out to be the wrong data structure.
      # A simple Disjoint Set does the trick
      #
      # Part 1 is destructive to the distances list, but this is intentional

      attr_accessor :connections

      def parse_input
        @connections = 1000
      end

      def part1
        @connections.times do
          _d, a, b = distances.shift
          d_set.union(a, b)
        end

        d_set.component_sizes.max(3).reduce(:*)
      end

      def part2
        # Keep adding edges until we have exactly 1 component
        distances.each do |_distance, a, b|
          d_set.union(a, b)

          if d_set.num_components == 1
            return a.x * b.x # This was the final edge needed
          end
        end
      end

      def d_set
        @d_set ||= DisjointSet.new.tap do |uf|
          # Initialize all points as separate components
          points.each { |p| uf.make_set(p) }
        end
      end

      def distances
        @distances ||= points.combination(2).map { |a, b| [a.sort_distance(b), a, b] }
          .sort_by(&:first)
      end

      def points
        @points ||= input_lines.map do |line|
          x, y, z = line.split(",").map(&:to_i)
          ThreePoint.new(x:, y:, z:)
        end
      end

      ThreePoint = Data.define(:x, :y, :z) do
        def sort_distance(other)
          dx = other.x - x
          dy = other.y - y
          dz = other.z - z
          dx * dx + dy * dy + dz * dz
        end

        # def distance(other)
        #   # d = √[(x₂ - x₁)² + (y₂ - y₁)² + (z₂ - z₁)²]
        #   ::Math.sqrt((other.x - x)**2 + (other.y - y)**2 + (other.z - z)**2)
        # end
      end
    end
  end
end
