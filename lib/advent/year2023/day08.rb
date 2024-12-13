# https://adventofcode.com/2023/day/08
module Advent
  module Year2023
    class Day08 < Advent::Challenge
      def part1
        current = nodes["AAA"]
        count = 0
        while current.id != "ZZZ"
          current = current.child(which_way(count))
          count += 1
        end

        count
      end

      def part2
        start_nodes = nodes.values.select(&:is_start?)

        paths = start_nodes.map do |current|
          count = 0
          until current.is_end?
            current = current.child(which_way(count))
            count += 1
          end

          count
        end

        paths.reduce(1, :lcm)
      end

      def which_way(count)
        # Handle looping instuctions
        directions[count % directions.size]
      end

      def directions
        @directions ||= input_lines.first.chars
      end

      def nodes
        @nodes ||= {}.tap do |new_nodes|
          input_lines.drop(2).each do |line|
            get_or_create_node = ->(id) { new_nodes[id] ||= Node.new(id) }

            matches = line.scan(/^(.{3}) = \((.{3}),\ (.{3})/).first
            parent, left, right = matches.map { |id| get_or_create_node[id] }
            parent.l = left
            parent.r = right
          end
        end
      end

      class Node
        attr_accessor :l, :r, :id
        def initialize(id)
          @id = id
        end

        def child(dir)
          {
            "L" => l,
            "R" => r
          }[dir]
        end

        def is_start?
          id[-1] == "A"
        end

        def is_end?
          id[-1] == "Z"
        end
      end
    end
  end
end
