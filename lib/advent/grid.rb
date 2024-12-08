module Advent
  class Grid
    attr_reader :rows, :width, :height
    def initialize(rows)
      @rows = rows
      @width = rows.first.size
      @height = rows.size
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
