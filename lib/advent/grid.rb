require "forwardable"

module Advent
  class Grid
    include Enumerable
    extend Forwardable
    def_delegators :@rows, :each

    attr_reader :rows, :width, :height

    def initialize(rows)
      @rows = rows
      @width = rows.first.size
      @height = rows.size
    end

    def [](y)
      rows[y]
    end

    def each_char
      rows.each_with_index do |row, y|
        row.chars.each_with_index do |char, x|
          yield char, row, x, y
        end
      end
    end

    def value_at(position)
      rows[position.y][position.x]
    end

    def adjacent_points_in_range(point)
      [
        Point.new(point.x, point.y - 1),
        Point.new(point.x, point.y + 1),
        Point.new(point.x - 1, point.y),
        Point.new(point.x + 1, point.y)
      ].select { |adjacent_point| in_range?(adjacent_point) }
    end

    def in_range?(point)
      x_in_range?(point.x) && y_in_range?(point.y)
    end

    def x_in_range?(x)
      (0..width - 1).cover?(x)
    end

    def y_in_range?(y)
      (0..height - 1).cover?(y)
    end
  end
end
