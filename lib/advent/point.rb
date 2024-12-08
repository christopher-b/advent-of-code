module Advent
  Point = Data.define(:x, :y) do
    def +(other)
      Point.new(x + other.x, y + other.y)
    end

    def x_in_range?(range)
      range.cover?(x)
    end

    def y_in_range?(range)
      range.cover?(y)
    end

    def to_s
      "(#{x}, #{y})"
    end
  end
end
