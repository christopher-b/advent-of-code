#!/usr/bin/env ruby
require "./advent"

class Advent
  class DayX < Day
    def start
      parse_file
      puts "Part 1: #{part_1}"
      # puts "Part 2: #{part_2}"
    end

    def part_1
      ""
    end

    def part_2
    end

    def parse_file
      each_line do |line|
      end
    end
  end
end

Advent::DayX.new("./inputX.txt").start
# Advent::DayX.new("./inputX_sample.txt").start
