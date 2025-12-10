# https://adventofcode.com/2025/day/09
module Advent
  module Year2025
    class Day09 < Advent::Challenge
      # Explanation here

      def part1
        all_rectangles.map(&:area).max
      end

      def part2
        # 4620654558 too high
        all_rectangles.select do |rect|
          rect.all_points.all? { |p| on_perimeter?(p) || interior_points.include?(p) }
          # rect.opposite_corners.all? { |corner| point_valid?(corner) }
        end.map(&:area).max
      end

      def all_rectangles
        @all_rectangles ||= tiles.combination(2).map do |a, b|
          Rectangle.new(a:, b:)
        end
      end

      def perimeter_edges
        @perimeter_edges ||= tiles.each_cons(2).to_a + [[tiles.last, tiles.first]]
      end

      def tiles
        @tiles ||= input_lines.map do |line|
          x, y = line.split(",").map(&:to_i)
          Point.new(x, y)
        end
      end

      def point_valid?(point)
        return true if on_perimeter?(point)  # Check edges directly

        intersections = 0
        perimeter_edges.each do |p1, p2|
          y_min, y_max = [p1.y, p2.y].minmax
          next unless point.y > y_min && point.y <= y_max
          next if p1.y == p2.y

          x_intersection = p1.x + (point.y - p1.y) * (p2.x - p1.x).to_f / (p2.y - p1.y)
          intersections += 1 if x_intersection > point.x
        end

        intersections.odd?
      end

      def on_perimeter?(point)
        perimeter_edges.any? do |p1, p2|
          # Check if point lies on the line segment from p1 to p2
          if p1.x == p2.x  # Vertical edge
            point.x == p1.x && point.y.between?(*[p1.y, p2.y].minmax)
          elsif p1.y == p2.y  # Horizontal edge
            point.y == p1.y && point.x.between?(*[p1.x, p2.x].minmax)
          else
            false  # No diagonal edges in this problem
          end
        end
      end

      def interior_points
        # puts "Flood! #{flood_start}"
        @interior_points ||= Set.new.tap do |ips|
          # Flood fill
          visited = Set.new([flood_start])
          queue = [flood_start]
          until queue.empty?
            point = queue.shift
            # puts "Checking #{point} (#{ips.size})"
            # visited << point
            ips << point

            point.cardinal_neighbors.each do |p|
              next if visited.include?(p)
              next if ips.include?(p) || perimeter_points.include?(p)
              # next if visited.include?(p) || perimeter_points.include?(p)
              # next if p.x < 0 || p.y < 0
              # next if p.x > max_x || p.y > max_y

              visited << p
              queue << p
            end
          end
        end
      end

      def max_x
        @max_x ||= tiles.map(&:x).max
      end

      def max_y
        @max_y ||= tiles.map(&:y).max
      end

      def flood_start
        start_y = max_y / 2

        (0..max_x).each do |x|
          point = Point.new(x, start_y)
          if perimeter_points.include? point
            result = point + Point::E

            # Handle landing on a corner
            if tiles.include? point
              # If the wall goes up, we go up
              result += if perimeter_points.include?(point + Point::N)
                Point::N
              else
                Point::S
              end
            end

            return result
          end
        end
        raise "Couldn't find an interior point"

        # # Simple heuristic: centroid of first few red tiles
        # sample = tiles[0..5]
        # cx = sample.sum(&:x) / sample.size
        # cy = sample.sum(&:y) / sample.size
        # Point.new(cx, cy)
        #
        #
        # # We know the first three points describe a ┘ spepe, so grab a point NW of the corner
        # tiles[1] + Point.new(-1, -1)
      end

      def perimeter_points
        @perimeter_points ||= Set.new.tap do |p|
          ts = tiles.dup

          # Start a a, but make sure we loop back to a
          a = ts.pop
          ts << a

          ts.each do |b|
            x_min, x_max = [a.x, b.x].minmax
            y_min, y_max = [a.y, b.y].minmax
            (x_min..x_max).each do |x|
              (y_min..y_max).each do |y|
                p << Point.new(x, y)
              end
            end
            a = b
          end
        end
      end

      Rectangle = Data.define(:a, :b) do
        def area
          (([a.x, b.x].max - [a.x, b.x].min) + 1) * (([a.y, b.y].max - [a.y, b.y].min) + 1)
        end

        def opposite_corners
          [Point.new(a.x, b.y), Point.new(b.x, a.y)]
        end

        def all_points
          pp ""
          pp a, b
          Set.new.tap do |points|
            x_min, x_max = [a.x, b.x].minmax
            y_min, y_max = [a.y, b.y].minmax
            (x_min..x_max).each do |x|
              points << Point.new(x, y_min)
              points << Point.new(x, y_max)
            end
            (y_min..y_max).each do |y|
              points << Point.new(x_min, y)
              points << Point.new(x_min, y)
            end
          end
        end
      end
    end
  end
end
