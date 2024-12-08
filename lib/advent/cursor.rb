module Advent
  class Cursor
    attr_reader :vector

    def initialize(vector)
      @vector = vector
    end

    def position
      vector.position
    end

    def direction
      vector.direction
    end

    def step
      @vector = next_vector
    end

    def next_vector
      vector.end_vector
    end

    def next_position
      vector.end_vector.position
    end
  end
end
