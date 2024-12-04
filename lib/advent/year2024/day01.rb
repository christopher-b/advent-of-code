# https://adventofcode.com/2024/day/1
module Advent
  module Year2024
    class Day01 < Advent::Challenge
      # The approach is to transform the two columns of values into arrays.
      # We can then sort them and apply the appropriate operations.

      def call
        puts "Part 1: #{part1}"
        puts "Part 2: #{part2}"
      end

      def part1
        distance(*lists)
      end

      def part2
        similarity(*lists)
      end

      # We get two columns of values. Rotate them into two lists, then sort
      def lists
        @lists ||= begin
          list1, list2 = input_lines.map { |line| line.split.map(&:to_i) }.transpose
          [list1.sort!, list2.sort!]
        end
      end

      # Get sum of absolute differences between two lists
      def distance(list1, list2)
        list1.zip(list2).map { |a, b| (a - b).abs }.sum
      end

      # Get sum of products of matching items in two lists
      def similarity(list1, list2)
        list1.reduce(0) do |total, item|
          total + (item * list2.count(item))
        end
      end
    end
  end
end
