#!/usr/bin/env ruby
require "./advent"

class Advent
  class Day6 < Day
    def start
      parse_file
      puts "Part 1: #{part_1}"
      puts "Part 2: #{part_2}"
    end

    def part_1
      @races.map(&:win_count).inject(:*)
    end

    def part_2
      @one_big_race.win_count
    end

    def parse_file
      @races = []
      input = []
      each_line do |line|
        input << line
      end

      @times = input[0].scan(/\d+/).map(&:to_i)
      @dists = input[1].scan(/\d+/).map(&:to_i)

      @times.each_with_index do |time, i|
        @races << Race.new(time, @dists[i])
      end

      @one_big_race = Race.new(@times.join.to_i, @dists.join.to_i)
    end
  end

  Race = Struct.new(:time, :target) do
    def max
      distance(mid)
    end

    def distance(press)
      press * (time - press)
    end

    def win_count
      return 0 if target >= max

      # Determine how far from the middle the target is
      offset = mid
      last_index = mid
      dist = max
      loop do
        offset /= 2
        offset += 1 if offset.odd? && offset > 1
        new_index = (dist > target) ? last_index - offset : last_index + offset

        dist = distance(new_index)
        last_index = new_index

        break if offset == 1
      end

      last_index += 1 if distance(last_index) <= target

      mod = time.odd? ? 2 : 1
      (mid - last_index) * 2 + mod
    end

    def mid
      time / 2
    end
  end
end

Advent::Day6.new("./input06.txt").start
