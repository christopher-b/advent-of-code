module Advent
  class Point
    attr_accessor :x, :y

    def initialize(x, y)
      @x = x
      @y = y
    end

    def +(other)
      Point.new(x + other.x, y + other.y)
    end

    def -(other)
      Point.new(x - other.x, y - other.y)
    end

    def *(scalar)
      Point.new(x * scalar, y * scalar)
    end

    def opposite
      Point.new(-x, -y)
    end

    def x_in_range?(range)
      range.cover?(x)
    end

    def y_in_range?(range)
      range.cover?(y)
    end

    def <=>(other)
      [x, y] <=> [other.x, other.y]
    end

    def ==(other)
      x == other.x && y == other.y
    end

    def to_s
      "(#{x}, #{y})"
    end

    def hash
      [x, y].hash
    end

    def eql?(other)
      self.hash == other.hash
    end

    class << self
      def cardinal_directions
        [N, E, S, W]
      end

      def cardinal_from(point)
        cardinal_directions.map { |dir| point + dir }
      end
    end
  end

  class Point
    N = new(0, -1)
    E = new(1, 0)
    S = new(0, 1)
    W = new(-1, 0)
  end
end
