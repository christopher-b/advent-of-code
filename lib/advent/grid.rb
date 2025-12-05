require "forwardable"

module Advent
  # A 2D grid data structure for working with character-based grids.
  # Provides methods for navigation, searching, and iteration over grid positions.
  #
  # @example Creating a grid
  #   rows = ["abc", "def", "ghi"]
  #   grid = Grid.new(rows)
  #   grid.width   # => 3
  #   grid.height  # => 3
  #
  # @example Finding and accessing values
  #   grid.find_first_char('e')  # => Point(1, 1)
  #   grid.value_at(Point.new(1, 1))  # => "e"
  class Grid
    # Exception raised when attempting to access a position outside the grid bounds.
    class OutOfRangeError < StandardError; end

    include Enumerable
    extend Forwardable
    # Delegates #each to @rows to support Enumerable operations
    def_delegators :@rows, :each

    # @return [Array<String>] The grid rows
    attr_reader :rows
    # @return [Integer] The width of the grid (number of columns)
    attr_reader :width
    # @return [Integer] The height of the grid (number of rows)
    attr_reader :height

    # Creates a new Grid from an array of rows.
    #
    # @param rows [Array<String>] Array of strings representing grid rows
    # @raise [NoMethodError] If rows is empty or rows don't have consistent width
    def initialize(rows)
      @rows = rows
      @width = rows.first.size
      @height = rows.size
    end

    # Accesses a row by index.
    #
    # @param y [Integer] The row index (0-based)
    # @return [String] The row at the given index
    def [](y)
      rows[y]
    end

    # Finds the first occurrence of a character in the grid.
    # Searches left-to-right, top-to-bottom.
    #
    # @param char [String] The character to search for
    # @return [Point, nil] The position of the first occurrence, or nil if not found
    def find_first_char(char)
      each_char do |current_char, x, y|
        return Point.new(x, y) if current_char == char
      end
      nil
    end

    # Iterates over each point in the grid with its character value.
    #
    # @yieldparam point [Point] The current position
    # @yieldparam char [String] The character at the current position
    # @return [Enumerator] If no block is given
    def each_point
      return to_enum(__method__) unless block_given?

      rows.each_with_index do |row, y|
        row.chars.each_with_index do |char, x|
          yield Point.new(x, y), char
        end
      end
    end

    # Iterates over each character in the grid with its coordinates.
    #
    # @yieldparam char [String] The character at the current position
    # @yieldparam x [Integer] The x-coordinate
    # @yieldparam y [Integer] The y-coordinate
    # @return [Enumerator] If no block is given
    def each_char
      return to_enum(__method__) unless block_given?

      rows.each_with_index do |row, y|
        row.chars.each_with_index do |char, x|
          yield char, x, y
        end
      end
    end

    # Gets the value at a specific position.
    #
    # @param position [Point] The position to query
    # @return [String] The character at the position
    # @raise [OutOfRangeError] If the position is outside the grid bounds
    def value_at(position)
      raise OutOfRangeError unless in_range?(position)

      rows[position.y][position.x]
    end

    # Sets the value at a specific position.
    #
    # @param position [Point] The position to modify
    # @param value [String] The new value (typically a single character)
    # @return [String] The value that was set
    # @raise [OutOfRangeError] If the position is outside the grid bounds
    def set_value_at(position, value)
      raise OutOfRangeError unless in_range?(position)

      rows[position.y][position.x] = value
    end

    # Returns adjacent points that are within grid bounds.
    # Points are returned in order: North, East, South, West (NESW).
    #
    # @param point [Point] The center point
    # @return [Array<Point>] Array of adjacent points (maximum 4, fewer at edges)
    # @example
    #   grid.adjacent_points_in_range(Point.new(1, 1))
    #   # => [Point(1,0), Point(2,1), Point(1,2), Point(0,1)]
    def adjacent_points_in_range(point)
      [
        Point.new(point.x, point.y - 1),
        Point.new(point.x + 1, point.y),
        Point.new(point.x, point.y + 1),
        Point.new(point.x - 1, point.y)
      ].select { |adjacent_point| in_range?(adjacent_point) }
    end

    # Returns diagonal points that are within grid bounds.
    # Points are returned in order: Northwest, Northeast, Southeast, Southwest.
    #
    # @param point [Point] The center point
    # @return [Array<Point>] Array of diagonal points (maximum 4, fewer at edges)
    # @example
    #   grid.diagonal_points_in_range(Point.new(1, 1))
    #   # => [Point(0,0), Point(2,0), Point(2,2), Point(0,2)]
    def diagonal_points_in_range(point)
      [
        Point.new(point.x - 1, point.y - 1),
        Point.new(point.x + 1, point.y - 1),
        Point.new(point.x + 1, point.y + 1),
        Point.new(point.x - 1, point.y + 1)
      ].select { |diagonal_point| in_range?(diagonal_point) }
    end

    # Checks if a point is within the grid bounds.
    #
    # @param point [Point] The point to check
    # @return [Boolean] True if the point is within bounds
    def in_range?(point)
      x_in_range?(point.x) && y_in_range?(point.y)
    end

    # Checks if an x-coordinate is within the grid width.
    #
    # @param x [Integer] The x-coordinate to check
    # @return [Boolean] True if x is within [0, width-1]
    def x_in_range?(x)
      (0..width - 1).cover?(x)
    end

    # Checks if a y-coordinate is within the grid height.
    #
    # @param y [Integer] The y-coordinate to check
    # @return [Boolean] True if y is within [0, height-1]
    def y_in_range?(y)
      (0..height - 1).cover?(y)
    end
  end
end
