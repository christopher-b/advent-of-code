module Advent
  class Cursor
    attr_reader :vector

    def initialize(vector)
      @vector = vector
    end

    def vector=(vector)
      @vector = vector
      @next_vector = nil
      @next_position = nil
    end

    def step
      self.vector = next_vector
    end

    def position
      vector.position
    end

    def direction
      vector.direction
    end

    def next_vector
      @next_vector ||= vector.end_vector
    end

    def next_position
      @next_position ||= vector.end_vector.position
    end
  end
end
