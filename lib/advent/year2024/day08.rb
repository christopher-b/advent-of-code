# https://adventofcode.com/2024/day/08
module Advent
  module Year2024
    class Day08 < Advent::Challenge
      # A simple one. We can use our `Vector` library class to interate steps until they fall off the grid.
      # This one takes about 10ms to run.

      def part1
        anitnodes.size
      end

      def part2
        antinodes_with_resonance.size
      end

      def anitnodes
        @anitnodes ||= Set.new.tap do |anodes|
          with_permutations do |a, b|
            vector = Vector.from_points(a, b)
            antinode1 = vector.step.step.position
            antinode2 = vector.step_back.position

            anodes << antinode1 if map.in_range?(antinode1)
            anodes << antinode2 if map.in_range?(antinode2)
          end
        end
      end

      def antinodes_with_resonance
        @anitnodes_with_resonance ||= Set.new.tap do |anodes|
          with_permutations do |a, b|
            [
              Vector.from_points(a, b),
              Vector.from_points(b, a)
            ].each do |vector|
              while map.in_range?(vector.position)
                anodes << vector.position
                vector = vector.step
              end
            end
          end
        end
      end

      def with_permutations
        node_sets.each do |nodes|
          nodes.permutation(2).each do |a, b|
            yield a, b
          end
        end
      end

      def map
        @map ||= Map.new(input_lines)
      end

      def node_sets
        map.node_sets.values
      end

      class Map < Advent::Grid
        def node_sets
          @nodes ||= Hash.new { |h, k| h[k] = [] }.tap do |nodes|
            rows.each_with_index do |row, y|
              row.chars.each_with_index do |char, x|
                unless char == "."
                  nodes[char] ||= []
                  nodes[char] << Point.new(x, y)
                end
              end
            end
          end
        end
      end
    end
  end
end

