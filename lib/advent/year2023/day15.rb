# https://adventofcode.com/2023/day/15
module Advent
  module Year2023
    class Day15 < Advent::Challenge
      # Explanation here

      def part1
        steps.map { Lens.hash _1 }.sum
      end

      def part2
        boxes = Hash.new { |h, k| h[k] = [] }
        steps.each do |step|
          lens = Lens.new(step)
          box = boxes[lens.box]

          if lens.op == "-"
            box.reject! { |old_lens| old_lens.label == lens.label }
          elsif lens.op == "="
            if (old_lens = box.find { _1.label == lens.label })
              box[box.index(old_lens)] = lens
            else
              box << lens
            end
          end
        end

        # Get focusing power
        power = 0
        boxes.each do |i, box|
          box.each_with_index do |lens, j|
            power += (i + 1) * (j + 1) * lens.focal_length
          end
        end
        power
      end

      def steps
        @steps ||= input_lines.map { _1.split "," }.flatten
      end

      class Lens
        attr_accessor :label, :op, :focal_length
        def initialize(step)
          @label, @op, @focal_length = step.split(/(=|-)/)
          @focal_length = @focal_length.to_i
        end

        def box
          Lens.hash label
        end

        def self.hash(str)
          current = 0
          str.chars.each do |c|
            current += c.ord
            current *= 17
            current %= 256
          end
          current
        end
      end
    end
  end
end
