# https://adventofcode.com/2024/day/04
module Advent
  module Year2024
    class Day04 < Advent::Challenge
      def call
        puts "Part 1: #{part1}"
        puts "Part 2: #{part2}"
      end

      def part1
        find_word("XMAS", vector_template: vector_set_omni).size
      end

      def part2
        # Find all the diagonal "MAS"s, then see how many "A"s overlap
        word_vectors = find_word("MAS", vector_template: vector_set_diag)

        # Get locations of "A"
        mids = word_vectors.map do |vector|
          vector.decrement
          vector.current
        end

        # Count how many "A"s overlap
        mids.tally.count { |_, v| v > 1 }
      end

      # Find all instances of a word in the grid
      # Returns an array of vectors, representing the last letter of the word
      # `orthogonals` indicates whether to search in all directions, or just diagonals
      def find_word(word, vector_template:)
        first_letter, *rest_of_letters = word.chars
        matching_vectors = []

        input_lines.each_with_index do |line, y|
          line.chars.each_with_index do |char, x|
            next unless char == first_letter

            # We found first letter, now scan in indicated directions
            origin = Point.new(x: x, y: y)
            vectors = initialize_vector_set(origin, vector_template)

            matching_vectors.concat(
              vectors.select do |vector|
                rest_of_letters.all? { |letter| vector.next_value == letter }
              end
            )
          end
        end

        matching_vectors
      end

      # Initialize a set of vectors with the same origin
      def initialize_vector_set(origin, vector_template)
        vector_template.map { |vector|
          vector.dup.tap { |v| v.current = origin }
        }
      end

      # Get a vector for each direction
      def vector_set_omni
        [-1, 0, 1].repeated_permutation(2).to_a
          .tap { |combos| combos.delete([0, 0]) }
          .map { |x, y| Vector.new(x:, y:, grid: input_lines) }
      end

      # Get a vector for each diagonal direction
      def vector_set_diag
        [-1, 1].repeated_permutation(2).to_a
          .tap { |combos| combos.delete([0, 0]) }
          .map { |x, y| Vector.new(x:, y:, grid: input_lines) }
      end

      Point = Data.define(:x, :y)

      class Vector
        attr_accessor :x, :y, :current

        def initialize(x:, y:, grid:, current: Point.new(x: 0, y: 0))
          @x = x
          @y = y
          @grid = grid
          @current = current
          @max_x = @grid.first.size - 1
          @max_y = @grid.size - 1
        end

        def next_value
          increment
          return false unless valid_position?(@current)

          @grid[current.y][current.x]
        end

        def valid_position?(point)
          point.x.between?(0, @max_x) && point.y.between?(0, @max_y)
        end

        def increment
          @current = Point.new(x: @current.x + x, y: @current.y + y)
        end

        def decrement
          @current = Point.new(x: @current.x - x, y: @current.y - y)
        end
      end
    end
  end
end
