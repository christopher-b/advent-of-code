# https://adventofcode.com/2024/day/25
module Advent
  module Year2024
    class Day25 < Advent::Challenge
      # Explanation here

      attr_reader :locks, :keys

      def part1
        fit_combos
      end

      def part2
      end

      def fit_combos
        count = 0
        locks.each do |lock|
          keys.each do |key|
            count += 1 if key.fit? lock
          end
        end

        count
      end

      def parse_input
        @locks = []
        @keys = []

        input_chunks.each do |chunk|
          lines = chunk.lines.map(&:chomp)
          if lines.first == "#####"
            @locks << Lock.new(lines)
          else
            @keys << Key.new(lines)
          end
        end
      end

      class Gizmo
        attr_reader :heights

        def initialize(chunk)
          @heights = chunk.map(&:chars).transpose.map do |row|
            row.count { |c| c == "#" } - 1
          end
        end

        def fit?(other)
          heights.zip(other.heights).all? { |h, o| h + o <= 5 }
        end
      end

      class Lock < Gizmo
      end

      class Key < Gizmo
      end
    end
  end
end
