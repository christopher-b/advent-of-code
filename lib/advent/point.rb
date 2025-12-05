module Advent
  # Represents a 2D point in a coordinate system.
  # Supports arithmetic operations and provides helper methods for neighbor calculations.
  #
  # @example Creating and manipulating points
  #   p1 = Point.new(3, 4)
  #   p2 = Point.new(1, 2)
  #   p1 + p2  # => Point(4, 6)
  #   p1 - p2  # => Point(2, 2)
  #   p1 * 2   # => Point(6, 8)
  #
  # @example Using cardinal directions
  #   origin = Point.new(5, 5)
  #   origin + Point::N  # => Point(5, 4)
  #   origin + Point::E  # => Point(6, 5)
  class Point
    # @return [Integer] The x-coordinate
    attr_accessor :x
    # @return [Integer] The y-coordinate
    attr_accessor :y

    # Creates a new Point.
    #
    # @param x [Integer] The x-coordinate
    # @param y [Integer] The y-coordinate
    def initialize(x, y)
      @x = x
      @y = y
    end

    # Adds two points together.
    #
    # @param other [Point] The point to add
    # @return [Point] A new point with summed coordinates
    def +(other)
      Point.new(x + other.x, y + other.y)
    end

    # Subtracts another point from this point.
    #
    # @param other [Point] The point to subtract
    # @return [Point] A new point with the difference
    def -(other)
      Point.new(x - other.x, y - other.y)
    end

    # Multiplies the point by a scalar.
    #
    # @param other [Numeric] The scalar multiplier
    # @return [Point] A new point with scaled coordinates
    def *(other)
      Point.new(x * other, y * other)
    end

    # Returns the opposite point (negated coordinates).
    #
    # @return [Point] A new point with negated x and y
    # @example
    #   Point.new(3, -4).opposite  # => Point(-3, 4)
    def opposite
      Point.new(-x, -y)
    end

    # Returns the four cardinal neighbor points (N, E, S, W).
    #
    # @return [Array<Point>] Array of four neighboring points
    # @example
    #   Point.new(5, 5).cardinal_neighbors
    #   # => [Point(5,4), Point(6,5), Point(5,6), Point(4,5)]
    def cardinal_neighbors
      [N, E, S, W].map { |dir| self + dir }
    end

    # Returns the four diagonal neighbor points (NE, SE, SW, NW).
    #
    # @return [Array<Point>] Array of four diagonal neighboring points
    # @example
    #   Point.new(5, 5).diagonal_neighbors
    #   # => [Point(6,4), Point(6,6), Point(4,6), Point(4,4)]
    def diagonal_neighbors
      [Point.new(x + 1, y - 1), Point.new(x + 1, y + 1), Point.new(x - 1, y + 1), Point.new(x - 1, y - 1)]
    end

    # Checks if the x-coordinate is within a given range.
    #
    # @param range [Range] The range to check
    # @return [Boolean] True if x is within the range
    def x_in_range?(range)
      range.cover?(x)
    end

    # Checks if the y-coordinate is within a given range.
    #
    # @param range [Range] The range to check
    # @return [Boolean] True if y is within the range
    def y_in_range?(range)
      range.cover?(y)
    end

    # Compares points for sorting.
    # Points are ordered first by x, then by y.
    #
    # @param other [Point] The point to compare with
    # @return [Integer] -1, 0, or 1
    def <=>(other)
      [x, y] <=> [other.x, other.y]
    end

    # Checks equality based on coordinates.
    #
    # @param other [Point] The point to compare with
    # @return [Boolean] True if coordinates are equal
    def ==(other)
      x == other.x && y == other.y
    end

    # Returns a string representation of the point.
    #
    # @return [String] String in format "(x, y)"
    def to_s
      "(#{x}, #{y})"
    end

    # Computes a hash value for the point.
    # Allows points to be used as hash keys.
    #
    # @return [Integer] The hash value
    def hash
      [x, y].hash
    end

    # Checks equality for hash operations.
    #
    # @param other [Point] The point to compare with
    # @return [Boolean] True if hashes are equal
    def eql?(other)
      hash == other.hash
    end

    class << self
      # Returns the four cardinal direction vectors.
      #
      # @return [Array<Point>] Array of [N, E, S, W] direction points
      def cardinal_directions
        [N, E, S, W]
      end

      # Returns the cardinal neighbors of a given point.
      #
      # @param point [Point] The center point
      # @return [Array<Point>] Array of four neighboring points
      def cardinal_from(point)
        cardinal_directions.map { |dir| point + dir }
      end
    end
  end

  # Cardinal direction constants
  class Point
    # North direction vector (up)
    N = new(0, -1)
    # East direction vector (right)
    E = new(1, 0)
    # South direction vector (down)
    S = new(0, 1)
    # West direction vector (left)
    W = new(-1, 0)
  end
end
