# https://adventofcode.com/2023/day/01
module Advent
  module Year2023
    class Day01 < Advent::Challenge
      def part1
        pattern = /\d/
        input_lines
          .map { |line| line.scan pattern }
          .map { |matches| [matches.first, matches.last].join.to_i }
          .sum
      end

      def part2
        pattern = /(?=(\d|one|two|three|four|five|six|seven|eight|nine))/
        input_lines
          .map { |line| line.scan(pattern).flatten }
          .map { |matches|
            nums = matches.map { |n| replace_num(n) }
            [nums.first, nums.last].join.to_i
          }
          .sum
      end

      def replace_num(num)
        names = %w[zero one two three four five six seven eight nine]
        if names.include? num
          names.index(num).to_s
        else
          num
        end
      end
    end
  end
end
