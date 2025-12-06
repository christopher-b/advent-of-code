# https://adventofcode.com/2025/day/06
module Advent
  module Year2025
    class Day06 < Advent::Challenge
      # For part 1, we transpose the table a reduce the list by the operation
      #
      # For part 2, since whitespace is significant, we scan the table right-to-left,
      # creating columns. We then operate on those columns in the same way as
      # in part 1

      def part1
        problems.sum(&:solution)
      end

      def part2
        ceph_problems.sum(&:solution)
      end

      def problems
        @problems ||= input_lines
          .map(&:split)
          .transpose
          .map { |data| Problem.new(data) }
      end

      def ceph_problems
        is_blank = proc { |group| group.all? { |s| s == " " } }
        input_lines
          .map(&:chars) # Create table of chars
          .transpose # Rotate table
          .reverse # Scan right-to-left
          .slice_when(&is_blank) # Group by blank lines
          .map { |group| group.reject(&is_blank) } # Remove blank columns
          .map { |group| CephProblem.new(group) }
      end

      class Problem
        def initialize(init)
          @op = init.pop.to_sym
          @nums = init.map(&:to_i)
        end

        def solution
          @nums.reduce(&@op)
        end
      end

      class CephProblem
        def initialize(cols)
          @op = cols.last.pop.to_sym
          @nums = cols
            .map(&:join)
            .map(&:to_i)
        end

        def add_col(col)
          @cols << col
        end

        def solution
          @nums.reduce(&@op)
        end
      end
    end
  end
end
