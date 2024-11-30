#!/usr/bin/env ruby
require "./advent"

class Advent
  class Day9 < Day
    def start
      parse_file
      puts "Part 1: #{part_1}"
      puts "Part 2: #{part_2}"
    end

    def part_1
      @sequences.sum(&:next_value)
    end

    def part_2
      @sequences.sum(&:prev_value)
    end

    def parse_file
      @sequences = each_line.map { |line| Sequence.new(line.split(" ").map(&:to_i)) }
    end
  end

  class Sequence
    def initialize(items = [])
      @items = items
    end

    def base_sequence
      @base_sequence ||= begin
        i = 0
        base_difs = []
        (@items.size - 1).times do
          base_difs << @items[i + 1] - @items[i]

          i += 1
        end
        Sequence.new base_difs
      end
    end

    def next_value
      @next_value ||= begin
        return 0 if @items.all?(&:zero?)

        @items.last + base_sequence.next_value
      end
    end

    def prev_value
      @prev_value ||= begin
        return 0 if @items.all?(&:zero?)

        @items.first - base_sequence.prev_value
      end
    end
  end
end

Advent::Day9.new("./input09.txt").start
