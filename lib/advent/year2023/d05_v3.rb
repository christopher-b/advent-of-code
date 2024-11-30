#!/usr/bin/env ruby
require "./advent"

class Advent
  class Day5 < Day
    def start
      @almanac = parse_file
      @reverse_almanac = parse_file(true)
      # puts "Part 1: #{part_1}"
      puts "Part 2: #{part_2}"
    end

    def part_1
      locations = @almanac.seeds.map { |s| @almanac.process(s) }.compact
      locations.min
    end

    def part_2
      # Gather endpoints
      # endpoints = Set.new([0])
      # endpoints |= @reverse_almanac.maps[0].endpoints
      # @reverse_almanac.maps[1..].each do |segment|
      #   endpoints |= segment.endpoints.map { segment.mapped_value(_1) }
      # end
      # pp endpoints
      # 60 56 37
      # 56 93 4
      #  y = f(x) =
      #    x if x < 56,
      #    x+4 if 56 <=x <= 92,
      #    x-37 if 93 <= x <= 96,
      #    x if x > 96
      # return

      seed_ranges = @almanac.seeds.each_slice(2).map do |pair|
        start = pair[0]
        stop = start + pair[1]
        (start...stop)
      end

      location = 0
      # location = 25320000
      location = 184903631
      loop do
        puts location if location % 10000 == 0
        # puts "Loop #{location}"
        seed = @reverse_almanac.process(location)
        return location if seed_ranges.any? { |range| range.cover? seed }
        location += 1
      end
    end

    def parse_file(inverse = false)
      almanac = Almanac.new
      target = nil

      each_line do |line|
        next if line.empty?
        case line
        when /^seeds:/
          almanac.seeds = line.scan(/(\d+)/).flatten.map(&:to_i)
        when /^[\w-]+ map:$/
          target = Map.new
          almanac.add_map(target)
        else
          parts = line.split(" ")
          dst = inverse ? parts[1] : parts[0]
          src = inverse ? parts[0] : parts[1]
          len = parts[2]

          target.add_range MapRange.new(dst.to_i, src.to_i, len.to_i)
        end
      end

      almanac.reverse if inverse
      almanac
    end
  end

  class Almanac
    attr_accessor :seeds, :maps
    def initialize
      @seeds = []
      @maps = []
    end

    def process(input)
      result = input
      @maps.each do |map|
        result = map.mapped_value(result)
      end

      result
    end

    def add_map(map)
      @maps << map
    end

    def reverse
      @maps.reverse!
    end
  end

  class Map
    def initialize
      @ranges = []
    end

    def add_range(range)
      @ranges << range
    end

    def mapped_value(input)
      @ranges.each do |range|
        value = range.mapped_value(input)
        return value if value
      end

      nil
    end

    def endpoints
      @endpoints ||= begin
        points = Set.new([0])
        @ranges.each do |range|
          points << range.src - 1
          points << range.src
          points << range.src + range.len - 1
          points << range.src + range.len
        end
      end
    end
  end

  MapRange = Struct.new(:dst, :src, :len) do
    def mapped_value(input)
      return nil unless range.cover? input

      offset = input - src
      dst + offset
    end

    def range
      @range ||= (src...src + len)
    end
  end
end

Advent::Day5.new("./input05.txt").start
