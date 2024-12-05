# https://adventofcode.com/2024/day/05
module Advent
  module Year2024
    class Day05 < Advent::Challenge
      # We index all rules by both digits, so we can easily find a rule for
      # a given pair by intersecting the values for each index.
      # Then we can compare rule with the pair to determine a match

      attr_accessor :rules, :updates

      def call
        parse_input
        puts "Part 1: #{part1}"
        puts "Part 2: #{part2}"
      end

      def part1
        sum_of_middle(correct_updates)
      end

      def part2
        sorted_updates = incorrect_updates.map do |update|
          update.sort do |a, b|
            case rule_for(a, b)
            when [] then 0
            when [a, b] then -1
            else 1
            end
          end
        end
        sum_of_middle(sorted_updates)
      end

      def correct_updates
        @correct_updates ||= updates.select do |update|
          update.combination(2).all? { |a, b| rule_matches?(a, b) }
        end
      end

      def rule_matches?(a, b)
        rule = rule_for(a, b)
        rule.empty? || rule == [a, b]
      end

      def incorrect_updates
        updates - correct_updates
      end

      def sum_of_middle(updates)
        updates.sum { |u| u[u.length / 2] }
      end

      # Find the rule that matches both a and b
      # They are indexed by the both numbers, so we can just intersect the arrays
      def rule_for(a, b)
        (rules[a] & rules[b]).flatten
      end

      def parse_input
        @rules = Hash.new { |h, k| h[k] = [] }
        chunks = input_text.split("\n\n")

        # Index rules on each digit
        chunks.first.each_line do |line|
          a, b = line.split("|").map(&:to_i)
          @rules[a] << [a, b]
          @rules[b] << [a, b]
        end

        @updates = chunks.last.each_line.map do |line|
          line.split(",").map(&:to_i)
        end
      end
    end
  end
end
