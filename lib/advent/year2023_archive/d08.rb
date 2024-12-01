#!/usr/bin/env ruby
require "./advent"

class Advent
  class Day8 < Day
    def start
      parse_file

      puts "Part 1: #{part_1}"
      puts "Part 2: #{part_2}"
    end

    def part_1
      current = @nodes["AAA"]
      count = 0
      while current.id != "ZZZ"
        current = current.child(which_way(count))
        count += 1
      end

      count
    end

    def part_2
      nodes = @nodes.values.select(&:is_start?)

      paths = nodes.map do |current|
        count = 0
        until current.is_end?
          current = current.child(which_way(count))
          count += 1
        end

        count
      end

      paths.reduce(1, :lcm)
    end

    def which_way(count)
      @directions[count % @directions.size]
    end

    def parse_file
      @nodes = {}
      @directions = nil

      each_line do |line|
        @directions ||= line.chars # First line

        next unless (matches = line.match(/^(.{3}) = \((.{3}),\ (.{3})/))

        nodes = *matches.to_a[1..3].map { |id| get_or_create_node(id) }
        nodes.shift.tap do |parent|
          parent.l = nodes.shift
          parent.r = nodes.shift
        end
      end
    end

    def get_or_create_node(id)
      @nodes[id] ||= Node.new(id)
    end
  end

  class Node
    attr_accessor :l, :r, :id
    def initialize(id)
      @id = id
    end

    def child(dir)
      {
        "L" => l,
        "R" => r
      }[dir]
    end

    def is_start?
      id[-1] == "A"
    end

    def is_end?
      id[-1] == "Z"
    end
  end
end

Advent::Day8.new("./input08.txt").start
