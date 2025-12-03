# https://adventofcode.com/2025/day/01
module Advent
  module Year2025
    class Day01 < Advent::Challenge
      # We apply a reduction on each rotation, tracking the times we cross zero.
      # The tricky part is around edge cases in the negative movement. We manually add a zero pass
      # when we land on zero, but we don't count cases where we start on zero. There's probably
      # and optimization here.

      INITIAL_POSITION = 50

      def part1
        zeros = 0
        rotations.reduce(INITIAL_POSITION) do |result, rotation|
          rotation.apply(result)
          zeros += 1 if rotation.result.zero?
          rotation.result
        end

        zeros
      end

      def part2
        zeros = 0
        rotations.reduce(INITIAL_POSITION) do |result, rotation|
          rotation.apply(result)
          zeros += rotation.zero_passes
          rotation.result
        end

        zeros
      end

      Rotation = Struct.new(:dir, :delta) do
        attr_reader :result, :zero_passes

        def apply(pos)
          @zero_passes = 0

          @result = case dir
          when "L"
            diff = pos - delta
            @zero_passes = (diff / 100).abs
            new_position = diff % 100
            @zero_passes += 1 if new_position.zero?
            @zero_passes -= 1 if pos.zero?

            new_position
          when "R"
            diff = pos + delta
            @zero_passes = diff / 100
            diff % 100
          else
            raise "invalid direction"
          end
        end
      end

      def rotations
        @rotations ||= each_line.map do |line|
          dir = line[0]
          delta = line[1..].to_i
          Rotation.new(dir, delta)
        end
      end
    end
  end
end
