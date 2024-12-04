# https://adventofcode.com/2023/day/09
module Advent
  module Year2023
    class Day09 < Advent::Challenge
      def call
        puts "Part 1: #{part1}"
        puts "Part 2: #{part2}"
      end

      def part1
        sequences.sum(&:next_value)
      end

      def part2
        sequences.sum(&:prev_value)
      end

      def sequences
        @sequences ||= input_lines.map { |line| Sequence.new(line.split.map(&:to_i)) }
      end

      class Sequence
        attr_accessor :items
        def initialize(items = [])
          @items = items
        end

        def base_sequence
          @base_sequence ||= begin
            i = 0
            base_difs = []
            (items.size - 1).times do
              base_difs << items[i + 1] - items[i]

              i += 1
            end
            Sequence.new base_difs
          end
        end

        def next_value
          @next_value ||= begin
            return 0 if items.all?(&:zero?)

            items.last + base_sequence.next_value
          end
        end

        def prev_value
          @prev_value ||= begin
            return 0 if items.all?(&:zero?)

            items.first - base_sequence.prev_value
          end
        end
      end
    end
  end
end
