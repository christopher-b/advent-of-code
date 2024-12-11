# https://adventofcode.com/2024/day/11
module Advent
  module Year2024
    class Day11 < Advent::Challenge
      # As we see from the example, the number of stones start to increase rapidly.
      # We can't simulate the whole process. We also only need to know the number
      # of stones after each blink, not the order of the stones. So we just track
      # the number of stones of each value. This also prevents us from needing to
      # make the same calculations multiple times.

      def part1
        stones.blink(25).size
      end

      def part2
        # Assumes part 1 has been run first
        stones.blink(50).size
      end

      def stones
        @stones ||= StoneSet.new(input_text.split.map(&:to_i))
      end

      class StoneSet
        attr_reader :stones

        def initialize(stone_list)
          @stones = stone_list.tally
          @stones.default = 0
        end

        def size
          @stones.values.sum
        end

        def blink(times = 1)
          times.times { transform_stones! }
          self
        end

        def transform_stones!
          new_stones = @stones.dup

          @stones.each do |value, count|
            next if count.zero?

            # We're applying the same operation to each stone of the same value, so
            # we increment by `count`
            if value.zero?
              new_stones[1] += count
            elsif even_length?(value)
              first, second = split_number(value)
              new_stones[first] += count
              new_stones[second] += count
            else
              new_stones[value * 2024] += count
            end

            # We've replaced the stones, so we remove them
            new_stones[value] -= count
          end

          @stones = new_stones
        end

        def even_length?(number)
          number.to_s.length.even?
        end

        def split_number(number)
          string_val = number.to_s
          mid = string_val.length / 2
          [string_val[0...mid], string_val[mid..]].map(&:to_i)
        end
      end
    end
  end
end
