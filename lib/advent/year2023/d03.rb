#!/usr/bin/env ruby
require "./advent"

class Advent
  class Day3 < Day
    def start
      @chunks = []
      @symbols = []
      parse_file
      parse_adjacency

      puts "Part 1: #{chunks_near_symbols.map(&:value).sum}"
      puts "Part 2: #{gears.map(&:ratio).sum}"
    end

    def parse_file
      each_line do |line, i|
        chunk_matches = line.to_enum(:scan, /(\d+)/).map { Regexp.last_match }
        @chunks |= chunk_matches.map { |m| NumberChunk.new(m, i) }

        sym_matches = line.to_enum(:scan, /[^\d\.]/).map { Regexp.last_match }
        @symbols |= sym_matches.map { |m| Part.new(m, i) }
      end
    end

    def parse_adjacency
      @symbols.each do |symbol|
        symbol.adjacent_chunks = @chunks.select { |c| c.point_in_margin? symbol.point }
      end
    end

    def chunks_near_symbols
      @chunks_near_symbols ||= @chunks.select do |chunk|
        # @TODO use existin gear parse
        @symbols.map(&:point).any? { |s| chunk.point_in_margin?(s) }
      end
    end

    def gears
      @gears ||= @symbols.select(&:is_gear?)
    end
  end

  class NumberChunk
    attr_reader :y, :value

    def initialize(match, y)
      @value = match[0].to_i
      @match = match
      @y = y
    end

    def margin
      @points ||= [].tap do |points|
        # L and R
        points << Point.new(start_x - 1, y)
        points << Point.new(end_x + 1, y)

        # T and B
        ((start_x - 1)..(end_x + 1)).each do |x|
          points << Point.new(x, y - 1)
          points << Point.new(x, y + 1)
        end
      end
    end

    def start_x
      @match.begin(0)
    end

    def end_x
      @match.end(0) - 1
    end

    def point_in_margin?(point)
      margin.include? point
    end
  end

  class Part
    attr_reader :point, :value
    attr_accessor :adjacent_chunks
    def initialize(match, i)
      @point = Point.new(match.begin(0), i)
      @value = match[0]
      @chunks = []
    end

    def is_gear?
      value == "*" && adjacent_chunks.size == 2
    end

    def ratio
      raise "Nope!" unless is_gear?

      adjacent_chunks[0].value * adjacent_chunks[1].value
    end
  end

  Point = Struct.new(:x, :y)
end

Advent::Day3.new("./input03.txt").start
