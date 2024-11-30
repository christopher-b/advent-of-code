#!/usr/bin/env ruby
require "./advent"

class Advent
  class Day1 < Day
    def start
      @values = []
      parse_file
      puts "Part 2: #{@values.sum}"
    end

    def parse_file
      each_line do |line|
        matches = line.scan(/(?=(\d|one|two|three|four|five|six|seven|eight|nine))/).flatten
        @values << [matches[0], matches[-1]].map { |n| check_num(n) }.join.to_i
      end
    end

    def check_num(num)
      names = %w[zero one two three four five six seven eight nine]
      if names.include? num
        names.index(num).to_s
      else
        num
      end
    end
  end
end

Advent::Day1.new("./input01.txt").start
