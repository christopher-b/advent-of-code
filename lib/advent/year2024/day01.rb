module Advent
  module Year2024
    class Day01 < Advent::Challenge
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

      def lists
        @lists ||= begin
          list1, list2 = input_lines.map { |line| line.split.map(&:to_i) }.transpose
          [list1.sort!, list2.sort!]
        end
      end

      def distance(list1, list2)
        list1.zip(list2).map { |a, b| (a - b).abs }.sum
      end

      def similarity(list1, list2)
        list1.reduce(0) do |score, item|
          score + (item * list2.count(item))
        end
      end
    end
  end
end
