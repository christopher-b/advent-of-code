module Advent
  Vector = Data.define(:position, :direction) do
    def end_vector
      Vector.new(position + direction, direction)
    end

    def to_s
      "#{position} -> #{direction}"
    end
  end
end
