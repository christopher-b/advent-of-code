# https://adventofcode.com/2024/day/10
module Advent
  module Year2024
    class Day10 < Advent::Challenge
      # Fast and easy. We recursively follow the path from each trailhead, counting the number of 9s we visit.

      def part1
        trail_map.total_score
      end

      def part2
        trail_map.total_rating
      end

      def trail_map
        @trail_map ||= TrailMap.new(input_lines.map { |line| line.chars.map(&:to_i) })
      end

      class Trailhead
        def initialize(origin, map)
          @map = map
          @nine_point_visits = Hash.new(0)

          follow_path(origin, 0)
        end

        def score
          @score ||= @nine_point_visits.keys.size
        end

        def rating
          @rating ||= @nine_point_visits.values.sum
        end

        def follow_path(point, height)
          if @map.value_at(point) == 9
            @nine_point_visits[point] += 1
          else
            next_points(point, height).each do |next_point|
              follow_path(next_point, height + 1)
            end
          end
        end

        def next_points(point, height)
          @map.adjacent_points_in_range(point).select do |adjacent_point|
            @map.value_at(adjacent_point) == height + 1
          end
        end
      end

      class TrailMap < Grid
        def total_score
          trailheads.sum(&:score)
        end

        def total_rating
          trailheads.sum(&:rating)
        end

        def trailheads
          @trailheads ||= [].tap do |ths|
            rows.each_with_index do |row, y|
              row.each_with_index do |height, x|
                ths << Trailhead.new(Point.new(x, y), self) if height == 0
              end
            end
          end
        end
      end
    end
  end
end
