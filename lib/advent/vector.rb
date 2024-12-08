module Advent
  Vector = Data.define(:position, :direction) do
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

    class << self
      def from_points(a, b)
        Vector.new(a, b - a)
      end
    end
  end
end
