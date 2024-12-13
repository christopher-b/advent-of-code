# https://adventofcode.com/2024/day/12
module Advent
  module Year2024
    class Day12 < Advent::Challenge
      # We do a simple scan to determine area of each region, checking matching adjacent points.
      # Perimeter of a point is 4 - number of adjacent points that match.
      # The number of sides matches the number of corners, which we can determine without fancy state tracking
      # I'm sure the corner checking could be more elegant but, ¯\_(ツ)_/¯

      def part1
        garden.regions.sum(&:fence_cost)
      end

      def part2
        garden.regions.sum(&:fence_bulk_cost)
      end

      def garden
        @gardern ||= GardenPlot.new(input_lines)
      end

      class GardenPlot < Grid
        Region = Struct.new(:perimeter, :area, :corners, :value) do
          def fence_cost
            perimeter * area
          end

          def fence_bulk_cost
            corners.size * area
          end
        end

        def initialize(rows)
          @visited = Set.new
          super
        end

        def regions
          @regions ||= [].tap do |rs|
            each_point do |point, char|
              # Recursively scan each cell that isn't part of a recognized region
              next if @visited.include?(point)
              rs << populate_region_info(point, char, Region.new(0, 0, Set.new, char))
            end
          end
        end

        private

        def populate_region_info(point, value, region)
          return region if @visited.include?(point)
          @visited << point

          # Find adjacent points in the same region
          matching_adjacent_points = adjacent_points_in_range(point).select do |adjacent_point|
            value_at(adjacent_point) == value
          end

          region.perimeter += 4 - matching_adjacent_points.size
          region.area += 1
          region.corners += detect_corners(point, value, region.corners)

          # Recurse
          matching_adjacent_points.each do |adjacent_point|
            populate_region_info(adjacent_point, value, region)
          end

          region
        end

        # Returns an array of corner points for the given point
        # We create 4 2x2 windows around the point, and check for matching values
        # We keep detected corners in a set to avoid double counting
        # A corner is described by the four points surrounding it
        # We could probably check for simple conditions to do early exits
        def detect_corners(point, value, existing_corners)
          [].tap do |corners|
            offsets = [
              [[0, 0], [1, 0], [1, 1], [0, 1]],
              [[0, 0], [0, 1], [-1, 1], [-1, 0]],
              [[0, 0], [-1, 0], [-1, -1], [0, -1]],
              [[0, 0], [0, -1], [1, -1], [1, 0]]
            ]

            offsets.each do |window_offsets|
              window = window_offsets.map { |dx, dy| Point.new(point.x + dx, point.y + dy) }

              values = window.map do |p|
                value_at(p)
              rescue Grid::OutOfRangeError
                nil
              end

              matching_value_count = values.count(value)

              case matching_value_count
              # 1: Only the original point is left, so we have a corner
              # 3: Some L-shape, so we have a corner
              when 1, 3 then corners << window.sort!
              when 2
                # If the two matching points are adjacent (value[1] and value[3]), that's not a corner
                # If two diagonal points match, that's a corner!
                # If two diagonal points match, and we've already found this corner in the same region, that's two corners!
                if values[0] == values[2] # [2] is the diagonal point
                  window << Point.new(-1, -1) if existing_corners.include?(window.sort) # Add a dummy point to indicate a second corner. This allows a second point in the set
                  corners << window.sort!
                end
              end # No corner if all 4 match
            end
          end
        end
        # End of GardenPlot
      end
    end
  end
end
