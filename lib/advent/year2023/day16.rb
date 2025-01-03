# https://adventofcode.com/2023/day/16
module Advent
  module Year2023
    class Day16 < Advent::Challenge
      MOVE_MATRIX = {
        "." => {"u" => "u", "d" => "d", "l" => "l", "r" => "r"},
        "-" => {"u" => "l", "d" => "l", "l" => "l", "r" => "r"},
        "|" => {"u" => "u", "d" => "d", "l" => "u", "r" => "u"},
        "/" => {"u" => "r", "d" => "l", "l" => "d", "r" => "u"},
        "\\" => {"u" => "l", "d" => "r", "l" => "u", "r" => "d"}
      }
      # Explanation here

      def part1
        # 5146 too low
        energized = []
        beams = [Point.new(-1, 0, "r")]
        until beams.empty?
          # print "\n"
          beam = beams.pop
          beam = beam.travel
          # print "Beam travels to #{beam.x} #{beam.y} (#{beam.dir})"
          next unless beam.on_grid?(grid)
          next if energized.include? beam

          energized << beam
          encounter = grid[beam.y][beam.x]
          if encounter == "|" && beam.horizontal?
            # print " (split!) "
            beams << Point.new(beam.x, beam.y, "d")
          elsif encounter == "-" && beam.vertical?
            # print " (split!) "
            beams << Point.new(beam.x, beam.y, "r")
          end

          beam.dir = MOVE_MATRIX[encounter][beam.dir]

          # print " .. hit #{encounter} and will move #{beam.dir}"

          beams << beam

          grid.each_with_index do |row, y|
            row.each_with_index do |col, x|
              en = energized.detect { |b| b.x == x && b.y == y }
              print (!!en) ? "#" : "."
            end
            print "\n"
          end

          # energized.uniq { |p| [p.x, p.y] }.size
          count = 0
          grid.each_with_index do |row, y|
            row.each_with_index do |col, x|
              count += 1 if energized.detect { |p| p.x == x && p.y == y }
            end
          end
          count
        end
      end

      def part2
      end

      def grid
        @grid ||= input_lines.map(&:chars)
      end

      Point = Struct.new(:x, :y, :dir) do
        def travel
          new_x, new_y = case dir
          when "u"
            [x, y - 1]
          when "d"
            [x, y + 1]
          when "l"
            [x - 1, y]
          when "r"
            [x + 1, y]
          else
            raise "Invalid direction"
          end
          Point.new(new_x, new_y, dir)
        end

        def vertical?
          dir == "u" || dir == "d"
        end

        def horizontal?
          dir == "l" || dir == "r"
        end

        def on_grid?(grid)
          wid = grid.first.size
          len = grid.size
          x >= 0 && y >= 0 && x < wid && y < len
        end
      end
    end
  end
end
