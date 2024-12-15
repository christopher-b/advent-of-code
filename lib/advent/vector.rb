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

    def to_s
      "#{position} -> #{direction}"
    end

    def ==(other)
      position == other.position && direction == other.direction
    end

    class << self
      def from_points(a, b)
        Vector.new(a, b - a)
      end
    end
  end
end
