# https://adventofcode.com/2024/day/13
module Advent
  module Year2024
    class Day13 < Advent::Challenge
      # I didn't know the equation for the solution, but I knew it was a system of linear equations.
      # I was able to phrase my question in a way that search / AI could help me find the answer.
      # The actual solution ended up being quite concise.

      def part1
        claw_machines.sum(&:cost)
      end

      def part2
        corrected_claw_machines.sum(&:cost)
      end

      def claw_machines
        @claw_machines ||= [].tap do |machines|
          input_text.split("\n\n").map do |chunk|
            lines = chunk.split("\n")
            ax, ay = extract_button(lines[0])
            bx, by = extract_button(lines[1])
            px, py = extract_prize(lines[2])
            machines << ClawMachine.new(ax, ay, bx, by, px, py)
          end
        end
      end

      def corrected_claw_machines
        @corrected_claw_machines ||= claw_machines.map do |machine|
          new_machine = machine.dup
          new_machine.px += 10000000000000
          new_machine.py += 10000000000000
          new_machine
        end
      end

      # Button A: X+1, Y+1
      def extract_button(line)
        line.scan(/X\+(\d*), Y\+(\d*)/).flatten.map(&:to_i)
      end

      # Prize: X=1, Y=1
      def extract_prize(line)
        line.scan(/X=(\d*), Y=(\d*)/).flatten.map(&:to_i)
      end

      class ClawMachine
        attr_accessor :ax, :ay, :bx, :by, :px, :py
        def initialize(ax, ay, bx, by, px, py)
          @ax = ax
          @ay = ay
          @bx = bx
          @by = by
          @px = px
          @py = py
        end

        def has_solution?
          !solution.nil?
        end

        def a_presses
          has_solution? ? solution[0] : nil
        end

        def b_presses
          has_solution? ? solution[1] : nil
        end

        def cost
          return 0 unless has_solution?

          (a_presses * 3) + b_presses
        end

        # Solve the system of linear equations
        # First equation: xa*j + xb*k = xp
        # Second equation: ya*j + yb*k = yp
        def solution
          @solution ||= begin
            # Check if system has a unique solution
            determinant = ax * by - ay * bx
            return nil if determinant == 0

            # Calculate j and k using Cramer's rule
            # j and k represent the number of presses for each button
            j = (px * by - py * bx) / determinant
            k = (ax * py - ay * px) / determinant

            # Ensure j and k are integers
            return nil unless j.is_a?(Integer) && k.is_a?(Integer)
            return nil unless ax * j + bx * k == px
            return nil unless ay * j + by * k == py

            [j, k]
          end
        end
      end
    end
  end
end
