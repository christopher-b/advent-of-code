#!/usr/bin/env ruby
require "./advent"

class Advent
  class Day5 < Day
    def start
      parse_file

      i = 0
      location_count = @location.ranges.map(&:size).sum

      @location.each_destination do |location|
        puts "Checking location #{location} (#{i / location_count * 100}% #{i}/#{location_count})"
        seed = seed_for_location(location)
        if seed
          puts "Found it! #{seed}"
          break
        end
        i += 1
      end

      # locations = @seeds.map { |s| location_for_seed(s) }
      # puts "Part 1: #{locations.min}"

      # pp "#{@seed_ranges.map(&:size).sum} seeds"
      # pp "#{@location.ranges.map(&:size).sum} locs"
      # pp @location.ranges
      # pp "--"
      # pp @location.ranges.sort

      # seed = @seeds.first
      # loc = location_for_seed(seed)
      # puts "Found location #{loc} for seed #{seed}"

      # more_locations = []
      # @seed_ranges.each do |range|
      #   range.each do |seed|
      #     more_locations << location_for_seed(seed)
      #   end
      # end
      # puts "Part 2: #{more_locations.min}"
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

    def seed_for_location(location)
      seed = @soil.src(
        @fertilizer.src(
          @water.src(
            @light.src(
              @temperature.src(
                @humidity.src(
                  @location.src(location)
                )
              )
            )
          )
        )
      )

      is_seed?(seed) ? seed : false
    end

    def is_seed?(seed)
      @seed_ranges.each do |range|
        return true if range.cover? seed
      end

      false
    end

    def parse_file
      @seeds = []
      # @seed_ranges = []
      @seed_ranges = Map.new("seed")
      @soil = Map.new("soil", @seed)
      @fertilizer = Map.new("fert", @soil)
      @water = Map.new("water", @fertilizer)
      @light = Map.new("light", @water)
      @temperature = Map.new("temp", @light)
      @humidity = Map.new("hum", @temperature)
      @location = Map.new("loc", @humidity)
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
      # Part 1
      seeds_pattern = /(\d+)/
      @seeds = seeds.scan(seeds_pattern).flatten.map(&:to_i)

      # Part 2
      @seed_ranges = @seeds.each_slice(2).map do |pair|
        start = pair[0]
        stop = start + pair[1]
        (start...stop)
      end
    end
  end

  class Map
    # include Enumerable
    attr_reader :ranges

    def initialize(name, parent = nil)
      @name = name
      @parent = parent
      @ranges = []
    end

    def src(dest)
      @ranges.each do |range|
        source = range.source(dest)
        return source if source
      end
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

    def each_destination
      @ranges.sort.each do |range|
        (range.dest...range.dest + range.length).each do |value|
          yield value
        end
      end
    end
  end

  MapRange = Struct.new(:dest, :src, :length) do
    alias_method :size, :length

    def destination(check_source)
      return false unless (src...src + length).cover? check_source

      offset = check_source - src
      dest + offset
    end

    def source(check_dest)
      return false unless (dest...dest + length).cover? check_dest

      offset = check_dest - dest
      src + offset
    end

    def <=>(other)
      dest <=> other.dest
    end
  end
end

# Advent::Day5.new("./input5_sample.txt").start
Advent::Day5.new("./input5.txt").start
