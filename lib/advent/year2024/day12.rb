# https://adventofcode.com/2024/day/12
module Advent
  module Year2024
    class Day12 < Advent::Challenge
      # We do a simple scan to determine area of each region, checking matching adjacent points.
      # Perimeter of a point is 4 - number of adjacent points that match.
      # The number of sides matches the number of corners, which we can determine without fancy state tracking
      # I'm sure the corner checking could be more elegant but, ¯\_(ツ)_/¯

      def part1
        regions.sum(&:fence_cost)
      end

      def part2
        regions.sum(&:fence_bulk_cost)
      end

      Region = Struct.new(:perimeter, :area, :corners, :value) do
        def fence_cost
          perimeter * area
        end

        def fence_bulk_cost
          corners.size * area
        end
      end

      def regions
        @regions ||= [].tap do |rs|
          map.each_point do |point, char|
            # Recursively scan each cell that isn't part of a recongized region
            next if visited.include?(point)
            rs << find_region(point, char, Region.new(0, 0, Set.new, char))
          end
        end
      end

      def find_region(point, value, region)
        return region if visited.include?(point)
        visited << point

        # Find adjacent points in the same region
        adjacent_points = map.adjacent_points_in_range(point).select do |adjacent_point|
          map.value_at(adjacent_point) == value
        end

        region.perimeter += 4 - adjacent_points.size
        region.area += 1
        region.corners += calculate_corners(point, value, region.corners)

        # Recurse
        adjacent_points.each do |adjacent_point|
          find_region(adjacent_point, value, region)
        end

        region
      end

      # Returns an array of corner points for the given point
      # We create 4 2x2 windows around the point, and check for matching values
      def calculate_corners(point, value, existing_corners)
        corners = []

        n = Point.new(point.x, point.y - 1)
        e = Point.new(point.x + 1, point.y)
        s = Point.new(point.x, point.y + 1)
        w = Point.new(point.x - 1, point.y)
        nw = Point.new(point.x - 1, point.y - 1)
        ne = Point.new(point.x + 1, point.y - 1)
        se = Point.new(point.x + 1, point.y + 1)
        sw = Point.new(point.x - 1, point.y + 1)

        windows = [
          [point, e, ne, n],
          [point, n, nw, w],
          [point, w, sw, s],
          [point, s, se, e]
        ]

        windows.each do |window|
          values = window.map do |p|
            map.value_at(p)
          rescue Grid::OutOfRangeError
            nil
          end

          matching_values = values.count(value)
          case matching_values
          # OO
          # OX
          when 1 then corners << window.sort!
          # OX or OO or XO
          # OX    XX    OX
          when 2
            # If two diagonal points match, that's a corner!
            # If two diagonal points match, and we've already found this corner in the same region, that's two corners!
            if values[0] == values[2] # [2] is the diagonal point
              window << Point.new(-1, -1) if existing_corners.include?(window.sort) # Add a dummy point to indicate a second corner
              corners << window.sort!
            end
          # XO or XX or OX
          # XX    OX    XX
          when 3 then corners << window.sort!
          end # No corner if all 4 match
        end

        corners
      end

      def map
        @map ||= Grid.new(input_lines)
      end

      def visited
        @visited ||= Set.new
      end
    end
  end
end
