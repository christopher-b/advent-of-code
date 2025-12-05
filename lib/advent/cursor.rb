module Advent
  # A cursor that tracks movement through a grid space using vectors.
  # Maintains state for the current vector and provides lookahead for the next position.
  #
  # @example Moving a cursor through a grid
  #   vector = Vector.new(position: Point.new(0, 0), direction: Point.new(0, 1))
  #   cursor = Cursor.new(vector)
  #   cursor.next_position  # => Point(0, 1)
  #   cursor.step          # Advances to next position
  #   cursor.position      # => Point(0, 1)
  class Cursor
    # @return [Vector] The current vector representing position and direction
    attr_reader :vector

    # Creates a new Cursor with the given vector.
    #
    # @param vector [Vector] The initial vector with position and direction
    def initialize(vector)
      @vector = vector
    end

    # Sets a new vector and clears memoized next_vector and next_position.
    #
    # @param vector [Vector] The new vector to set
    # @return [Vector] The vector that was set
    def vector=(vector)
      @vector = vector
      @next_vector = nil
      @next_position = nil
    end

    # Advances the cursor by moving to the next vector.
    # Updates the current vector to the previously calculated next_vector.
    #
    # @return [Vector] The new current vector after stepping
    def step
      self.vector = next_vector
    end

    # Returns the current position of the cursor.
    #
    # @return [Point] The current position
    def position
      vector.position
    end

    # Returns the current direction of the cursor.
    #
    # @return [Symbol] The current direction (e.g., :up, :down, :left, :right)
    def direction
      vector.direction
    end

    # Returns the vector that would result from taking a step.
    # The result is memoized until the vector changes.
    #
    # @return [Vector] The next vector
    def next_vector
      @next_vector ||= vector.end_vector
    end

    # Returns the position that would result from taking a step.
    # The result is memoized until the vector changes.
    #
    # @return [Point] The next position
    def next_position
      @next_position ||= vector.end_vector.position
    end
  end
end
