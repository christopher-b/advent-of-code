# https://adventofcode.com/2023/day/06
module Advent
  module Year2023
    class Day06 < Advent::Challenge
      def part1
        races.map(&:win_count).inject(:*)
      end

      def part2
        one_big_race.win_count
      end

      def races
        @races ||= times.zip(dists).map { |time, dist| Race.new(time, dist) }
      end

      def one_big_race
        @one_big_race ||= Race.new(
          races.map(&:time).join.to_i,
          races.map(&:target).join.to_i
        )
      end

      def times
        @times ||= input_lines.first.scan(/\d+/).map(&:to_i)
      end

      def dists
        @dists ||= input_lines.last.scan(/\d+/).map(&:to_i)
      end

      Race = Struct.new(:time, :target) do
        def win_count
          return 0 if target >= max

          last_index = binary_search
          mod = time.odd? ? 2 : 1
          (mid - last_index) * 2 + mod
        end

        private

        def binary_search
          offset = mid
          last_index = mid
          dist = max

          while offset > 1
            offset /= 2
            offset += 1 if offset.odd? && offset > 1
            new_index = (dist > target) ? last_index - offset : last_index + offset
            dist = distance(new_index)
            last_index = new_index
          end

          last_index += 1 if distance(last_index) <= target
          last_index
        end

        def max
          distance(mid)
        end

        def distance(press)
          press * (time - press)
        end

        def mid
          time / 2
        end
      end
    end
  end
end
