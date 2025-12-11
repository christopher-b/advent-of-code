# https://adventofcode.com/2025/day/09
module Advent
  module Year2025
    class Day09 < Advent::Challenge
      # Part 1: Brute force
      # Part 2: Contract each rectangle by one tile, then check for intersections with the perimeter
      # We can trim the time by keeping track of our largest rectange so far, and not bothering checking
      # the intersections for smaller.
      # We do some optimzitions, like sorting rectangles by area, which we have alread computed for part 1
      # These bring the compute time from ~30s to ~5s

      def part1
        all_rectangles.map(&:area).max
      end

      def part2
        all_rectangles.sort_by(&:area).reverse_each do |rect|
          valid = rect.contracted_edge_segments.none? do |seg|
            perimeter_segments.any? { |p_seg| p_seg.intersect?(seg) }
          end
          return rect.area if valid
        end
        0
      end

      def all_rectangles
        @all_rectangles ||= tiles.combination(2).map do |a, b|
          Rectangle.new(a, b)
        end
      end

      def perimeter_segments
        @perimeter_segments ||= Set.new.tap do |segs|
          tiles.each_cons(2) do |a, b|
            segs << Segment.new(a, b)
          end
          segs << Segment.new(tiles.last, tiles.first)
        end
      end

      def tiles
        @tiles ||= input_lines.map do |line|
          x, y = line.split(",").map(&:to_i)
          Point.new(x, y)
        end
      end

      class Segment
        attr_accessor :a, :b
        def initialize(a, b)
          @a = a
          @b = b
        end

        def x_range
          @x_range ||= [a.x, b.x].minmax
        end

        def y_range
          @y_range ||= [a.y, b.y].minmax
        end

        def intersect?(other)
          x1_min, x1_max = x_range
          y1_min, y1_max = y_range
          x2_min, x2_max = other.x_range
          y2_min, y2_max = other.y_range

          x1_max >= x2_min && x2_max >= x1_min &&
            y1_max >= y2_min && y2_max >= y1_min
        end
      end

      class Rectangle
        attr_accessor :a, :b

        def initialize(a, b)
          @a = a
          @b = b
        end

        def area
          @area ||= (max_x - min_x + 1) * (max_y - min_y + 1)
        end

        def contracted_edge_segments
          [
            Segment.new(t_l, t_r),
            Segment.new(t_r, b_r),
            Segment.new(b_r, b_l),
            Segment.new(b_l, t_l)
          ]
        end

        def t_l = Point.new(min_x, min_y) + Point.new(1, 1)

        def t_r = Point.new(max_x, min_y) + Point.new(-1, 1)

        def b_l = Point.new(min_x, max_y) + Point.new(1, -1)

        def b_r = Point.new(max_x, max_y) + Point.new(-1, -1)

        def max_x = [a.x, b.x].max

        def min_x = [a.x, b.x].min

        def max_y = [a.y, b.y].max

        def min_y = [a.y, b.y].min

        def opposite_corners
          [Point.new(a.x, b.y), Point.new(b.x, a.y)]
        end
      end
    end
  end
end
