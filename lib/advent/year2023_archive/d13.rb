#!/usr/bin/env ruby
require "./advent"

class Advent
  class Day13 < Day
    def start
      parse_file
      puts "Part 1: #{part_1}"
      # puts "Part 2: #{part_2}"
    end

    def part_1
      # 35143 is too high
      # 29681 is loo low
      @patterns.each do |p|
        next unless p.vertical_lines.size > 1 || p.horizontal_lines.size > 1
        puts p.vertical_lines.size
        puts p.horizontal_lines.size
        p.lines.first.each_with_index { print _2.to_s(16) }
        puts "\n"
        p.lines.each { puts _1.join "" }
        puts "H: #{p.horizontal_lines} V: #{p.vertical_lines} S: #{p.summary}"
        puts "\n\n"
      end
      @patterns.map(&:summary).sum
    end

    def part_2
    end

    def parse_file
      @patterns = []
      pattern = new_pattern
      each_line do |line|
        pattern = new_pattern if line.empty?
        pattern.add_line(line)
      end
    end

    def new_pattern
      Pattern.new.tap { |p| @patterns << p }
    end
  end

  class Pattern
    attr_reader :lines

    def initialize
      @lines = []
    end

    def summary
      sum = 0
      vertical_lines.each do |vertical_line|
        sum += (vertical_line + 1)
      end
      horizontal_lines.each do |horizontal_line|
        sum += (100 * (horizontal_line + 1))
      end
      sum
    end

    def vertical_lines
      find_symmetry_lines(@lines.transpose)
    end

    def horizontal_lines
      find_symmetry_lines(@lines)
    end

    def find_symmetry_lines(items)
      [].tap do |lines|
        items.each_with_index do |line, i|
          j = 0
          loop do
            bottom_i = i + j + 1
            top_i = i - j
            j += 1

            limit = top_i == 0 || bottom_i == @lines.size - 1
            match = items[top_i] == items[bottom_i]

            if match && limit
              lines << i
              break
            end
            # return i if match && limit
            break if !match
          end
        end
      end
    end

    def add_line(line)
      @lines << line.chars unless line.empty?
    end
  end
end

# Advent::Day13.new("./input13_sample.txt").start
Advent::Day13.new("./input13.txt").start
