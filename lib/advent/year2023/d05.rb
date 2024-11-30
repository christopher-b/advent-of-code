#!/usr/bin/env ruby
require "./advent"

class Advent
  class Day5 < Day
    def start
      parse_file

      locations = @seeds.map { |s| location_for_seed(s) }
      puts "Part 1: #{locations.min}"

      more_locations = []
      @seed_ranges.each do |range|
        first_seed = range.first
        last_seed = range.last
        # range.each do |seed|
        more_locations << location_for_seed(first_seed)
        more_locations << location_for_seed(last_seed)
        # end
      end
      puts "Part 2: #{more_locations.min}"
    end

    def location_for_seed(seed)
      @location.dest(
        @humidity.dest(
          @temperature.dest(
            @light.dest(
              @water.dest(
                @fertilizer.dest(
                  @soil.dest(seed)
                )
              )
            )
          )
        )
      )
    end

    def parse_file
      @seeds = []
      @seed_ranges = []
      @soil = Map.new
      @fertilizer = Map.new
      @water = Map.new
      @light = Map.new
      @temperature = Map.new
      @humidity = Map.new
      @location = Map.new
      target = nil

      each_line do |line|
        next if line.empty?

        case line
        when /^seeds:/
          parse_seeds(line)
        when /^seed-to-soil/
          target = @soil
        when /^soil-to-fertilizer/
          target = @fertilizer
        when /^fertilizer-to-water/
          target = @water
        when /^water-to-light/
          target = @light
        when /^light-to-temperature/
          target = @temperature
        when /^temperature-to-humidity/
          target = @humidity
        when /^humidity-to-location/
          target = @location
        else
          target.add_line(line)
        end
      end
    end

    def parse_seeds(seeds)
      seeds_pattern = /(\d+)/
      @seeds = seeds.scan(seeds_pattern).flatten.map(&:to_i)
      @seed_ranges = @seeds.each_slice(2).map do |pair|
        start = pair[0]
        stop = start + pair[1]
        (start...stop)
      end
    end
  end

  class Map
    def initialize
      @ranges = []
    end

    def dest(src)
      @ranges.each do |range|
        destination = range.destination(src)
        return destination if destination
      end

      src
    end

    def add_line(line)
      dest, src, length = line.split(" ")
      @ranges << MapRange.new(dest.to_i, src.to_i, length.to_i)
    end
  end

  MapRange = Struct.new(:dest, :src, :length) do
    def destination(check_source)
      return false unless (src...src + length).cover? check_source

      offset = check_source - src
      dest + offset
    end
  end
end

# Advent::Day5.new("./input5_sample.txt").start
Advent::Day5.new("./input5.txt").start
