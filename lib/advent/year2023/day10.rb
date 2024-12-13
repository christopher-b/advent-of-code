# https://adventofcode.com/2023/day/10
module Advent
  module Year2023
    class Day10 < Advent::Challenge
      def part1
        a, b = @origin.connections
        last_a = last_b = @origin
        count = 1
        while a != b
          count += 1
          a, last_a = a.follow_from(last_a), a
          b, last_b = b.follow_from(last_b), b
        end
        count
      end

      def part2
        count = 0
        in_loop = false

        input_lines.each_with_index do |row, row_i|
          row.chars.each_with_index do |_, col_i|
            tile = Tile.new(col_i, row_i)
            is_path_tile = path_tiles.include?(tile)

            in_loop = !in_loop if is_path_tile && tile.points_north?
            count += 1 if in_loop && !is_path_tile
          end
        end
        count
      end

      def path_tiles
        @path_tiles ||= begin
          tiles = Set.new([@origin])
          nxt = @origin.connections.first
          lst = @origin

          until nxt == @origin
            tiles << nxt
            nxt, lst = nxt.follow_from(lst), nxt
          end
          tiles
        end
      end

      def parse_input
        start_row = input_lines.find_index(input_lines.find { |line| line.include? "S" })
        start_col = input_lines[start_row].index "S"
        @origin = Tile.new(start_col, start_row)

        Tile.lines = input_lines
      end

      class Tile
        attr_reader :x, :y

        def initialize(x, y)
          @x = x
          @y = y
        end

        def follow_from(tile)
          connections.find { |c| c != tile }
        end

        def points_north?
          %w[| L J S].include? value
        end

        def connections
          @connections ||= case value
          when "|" then [north, south]
          when "-" then [east, west]
          when "L" then [north, east]
          when "J" then [north, west]
          when "7" then [south, west]
          when "F" then [east, south]
          when "." then []
          when "S"
            [north, south, east, west].select { |tile| tile.connections.include? self }
            # Get all connections. determine which backref this one
          end
        end

        def value
          self.class.lines[y][x]
        end

        def move(x_delta, y_delta)
          Tile.new(x + x_delta, y + y_delta)
        end

        def ==(other)
          x == other.x && y == other.y
        end

        def eql?(other)
          self == other
        end

        def hash
          [x, y].hash
        end

        def north
          @north ||= move(0, -1)
        end

        def south
          @south ||= move(0, 1)
        end

        def east
          @east ||= move(1, 0)
        end

        def west
          @west ||= move(-1, 0)
        end

        def self.lines=(lines)
          @lines = lines
        end

        def self.lines
          @lines
        end
      end
    end
  end
end
