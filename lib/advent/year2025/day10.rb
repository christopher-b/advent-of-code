# https://adventofcode.com/2025/day/10
require "z3"

module Advent
  module Year2025
    class Day10 < Advent::Challenge
      # It's always fun to use bitwise math. Part 1 is a BFS on the soltion space.
      # Part 2 eluded me, but I discovered Z3 as a way to approach this kind of problem.

      def part1
        machines.sum(&:solve_lights)
      end

      def part2
        machines.sum(&:solve_joltage)
      end

      def machines
        @machines ||= input_lines.map do |line|
          Machine.new(line)
        end
      end

      class Machine
        def initialize(line)
          @parts = line.split(" ")
        end

        def solve_lights
          queue = [[0, 0]]  # [state, count]
          visited = Set.new([0])

          until queue.empty?
            state, count = queue.shift

            button_masks.each do |btn|
              new_state = state ^ btn
              return count + 1 if new_state == lights_target

              unless visited.include?(new_state)
                visited.add(new_state)
                queue << [new_state, count + 1]
              end
            end
          end

          raise "No solutions found!"
        end

        def solve_joltage
          # Find the min number of presses that satisfy the contstrains
          solver = Z3::Optimize.new

          # Set up our press counters
          presses = []
          buttons.each_index do |i|
            btn_presses = Z3::Int("button_#{i}")
            solver.assert(btn_presses >= 0)
            presses << btn_presses
          end

          joltage_target.each_with_index do |value, counter|
            affecting_buttons = buttons.filter_map.with_index { |btn, b| b if btn.include?(counter) }

            # Assert that the sum of presses for these buttons equals the target value
            solver.assert(
              affecting_buttons.map { |b| presses[b] }.sum == value
            )
          end

          # Find the smallest solution
          solver.minimize(presses.sum)

          raise "No solution found" unless solver.satisfiable?

          # Return the sum of presses
          presses.map { |press| solver.model[press].to_i }.sum
        end

        def width
          @width ||= @parts.first.size - 2
        end

        def lights_target
          @lights_target ||= @parts.first[1..-2]
            .chars
            .map { |x| (x == ".") ? "0" : "1" }
            .join
            .to_i(2)
        end

        def joltage_target
          @joltage_target ||= @parts.last
            .delete_prefix("{")
            .delete_suffix("}")
            .split(",")
            .map(&:to_i)
        end

        def buttons
          @buttons ||= @parts[1..-2]
            .map do |button_string|
            button_string
              .delete_suffix(")")
              .delete_prefix("(")
              .split(",")
              .map(&:to_i)
          end
        end

        def button_masks
          @button_masks ||= buttons.map do |button|
            button.inject(0) { |result, pos| result | (1 << (width - 1 - pos)) }
          end
        end
      end
    end
  end
end
