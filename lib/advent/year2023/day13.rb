# https://adventofcode.com/2023/day/13
module Advent
  module Year2023
    class Day13 < Advent::Challenge
      # Explanation here

      def part1
        patterns.each do |p|
          next unless p.vertical_lines.size > 1 || p.horizontal_lines.size > 1
          puts p.vertical_lines.size
          puts p.horizontal_lines.size
          p.lines.first.each_with_index { print _2.to_s(16) }
          puts "\n"
          p.lines.each { puts _1.join "" }
          puts "H: #{p.horizontal_lines} V: #{p.vertical_lines} S: #{p.summary}"
            puts "\n\n"
        end
        patterns.map(&:summary).sum
      end

      def part2
      end

      def patterns
        @patterns ||= [].tap do |ps|
          input_text.split("\n\n").each do |chunk|
            ps << Pattern.new(chunk.split("\n"))
          end
        end
      end

      class Pattern
        attr_reader :lines

        def initialize(lines)
          @lines = lines
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
  end
end
