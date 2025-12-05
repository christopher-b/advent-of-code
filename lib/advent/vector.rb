module Advent
  class Vector
    attr_accessor :position, :direction

    def initialize(position, direction)
      @position = position
      @direction = direction
    end

    def end_vector
      Vector.new(position + direction, direction)
    end
    alias_method :step, :end_vector

    def step_back
      Vector.new(position - direction, direction)
    end

    def rotate_clockwise
      Vector.new(position, Point.new(direction.y, -direction.x))
    end

    def rotate_counter_clockwise
      Vector.new(position, Point.new(-direction.y, direction.x))
    end

    def ==(other)
      position == other.position && direction == other.direction
    end

    def to_s
      "#{position} -> #{direction}"
    end

    def hash
      [position, direction].hash
    end

    def eql?(other)
      hash == other.hash
    end

    class << self
      def from_points(a, b)
        Vector.new(a, b - a)
      end
    end
  end
end
