#!/usr/bin/env ruby
require "./advent"

class Advent
  class Day10 < Day
    def start
      parse_file
      # puts part_1
      puts part_2
    end

    def part_1
      a, b = @origin.connections
      last_a = @origin
      last_b = @origin
      count = 1
      until a == b
        count += 1

        new_a = a.follow_from last_a
        new_b = b.follow_from last_b

        last_a = a
        last_b = b

        a = new_a
        b = new_b
      end

      count
    end

    def part_2
      count = 0
      in_loop = false

      @lines.each_with_index do |row, row_i|
        row.chars.each_with_index do |col, col_i|
          tile = Tile.new(col_i, row_i)
          is_path_tile = path_tiles.include?(tile)

          if is_path_tile && tile.points_north?
            in_loop = !in_loop
            # print in_loop ? "T" : "F"
          elsif in_loop && !is_path_tile
            # print "+"
            count += 1 if in_loop
          else
            # print "."
          end
        end
        # print "="
      end
      count
    end

    def path_tiles
      @path_tiles ||= begin
        tiles = Set.new
        nxt = @origin.connections.first
        lst = @origin

        tiles << @origin
        until nxt == @origin
          tiles << nxt
          new_nxt = nxt.follow_from(lst)
          lst = nxt
          nxt = new_nxt
        end
        tiles
      end
    end

    def parse_file
      @lines = each_line
      start_row = @lines.find_index(@lines.find { |line| line.include? "S" })
      start_col = @lines[start_row].index "S"
      @origin = Tile.new(start_col, start_row)

      Tile.lines = @lines
    end
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
      @west ||= move(-1, -0)
    end

    def self.lines=(lines)
      @lines = lines
    end

    def self.lines
      @lines
    end
  end
end

Advent::Day10.new("./input10.txt").start
