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
        list1 = []
        list2 = []

        lines.each do |line|
          items = line.split
          list1 << items[0].to_i
          list2 << items[1].to_i
        end

        [list1.sort!, list2.sort!]
      end

      def distance(list1, list2)
        list1.zip(list2).map { |a, b| (a - b).abs }.sum
      end

      def similarity(list1, list2)
        score = 0
        list1.each do |item|
          score += item * list2.count(item)
        end
        score
      end
    end
  end
end
