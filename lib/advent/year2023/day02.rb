# https://adventofcode.com/2023/day/02
module Advent
  module Year2023
    class Day02 < Advent::Challenge
      def part1
        games.reject { |g| g.max_red > 12 || g.max_green > 13 || g.max_blue > 14 }.map(&:id).sum
      end

      def part2
        games.map(&:power).sum
      end

      def games
        @games ||= input_lines.map { |line| Game.new(line) }
      end
    end

    class Game
      attr_accessor :id
      def initialize(line)
        parts = line.split(/:|;/).map(&:strip)
        @id = parts.shift.match(/^Game (\d+)/)[1].to_i
        @pulls = parts.map { |p| Pull.new(p) }
      end

      def max_red
        @pulls.map(&:r).compact.max
      end

      def max_green
        @pulls.map(&:g).compact.max
      end

      def max_blue
        @pulls.map(&:b).compact.max
      end

      def power
        max_red * max_green * max_blue
      end
    end

    Pull = Struct.new(:r, :g, :b) do
      def initialize(string)
        red = string.match(/(\d+) red/) { |m| m[1].to_i }
        green = string.match(/(\d+) green/) { |m| m[1].to_i }
        blue = string.match(/(\d+) blue/) { |m| m[1].to_i }
        super(red, green, blue)
      end
    end
  end
end
