# https://adventofcode.com/2024/day/07
module Advent
  module Year2024
    class Day07 < Advent::Challenge
      # My initial approach was to generate a list of all possible operator sets using repeated_permutation
      # and `zip`ing them with the operands. Then I would reduce the equation to a single value.
      #
      # I then realized I could do a recursive reduce-like operation to do depth-first search. This had
      # the advantages of:
      #  - Reducing the number of calculations needed
      #  - Returning early if we found a match
      #  - Returning early if a calculation exceeded the target value
      #
      # This method completes both parts in about 2 seconds. There's room for other optimizations, like, checking
      # if a multiplication of all operands is less than the target value, we can skip that branch.
      # I'm sure there's a fancy graph theory approach that could be even faster.
      #
      # This challenge also provided a chance to use `refinement` to add a `concat` method to integers.
      # This allows us to just use `Integer#send`, rather that swtich on the operator.

      def part1
        calibrations.select(&:valid?).sum(&:value)
      end

      def part2
        calibrations
          .select { |calibration| calibration.valid?(%w[+ * concat]) }
          .sum(&:value)
      end

      def calibrations
        @calibrations ||= input_lines.map do |line|
          value, operands = line.split(": ")
          Calibration.new(value.to_i, operands.split.map(&:to_i))
        end
      end

      # Add a `concat` method to integers
      module IntegerRefinements
        refine Integer do
          def concat(other)
            "#{self}#{other}".to_i
          end
        end
      end

      class Calibration
        include Comparable
        using IntegerRefinements

        attr_reader :value, :operands

        def initialize(value, operands)
          @value = value
          @operands = operands
        end

        # Recursively check all possible combinations of operators
        # We have default values for operators, total, and operands to make the recursion easier
        # We duplicate the operands because it's easier to mutate it
        def valid?(operators = %w[+ *], total = nil, operands = self.operands.dup)
          total = operands.shift if total.nil?

          # Return early if we've exceeded the target
          return false if total > value

          # This is the end of the calculation
          return total == value if operands.empty?

          operators.any? do |operator|
            # Perform the calculation
            new_total = total.send(operator, operands.first)

            # Keep iterating
            valid?(operators, new_total, operands[1..])
          end
        end

        def <=>(other)
          [value, operands] <=> [other.value, other.operands]
        end
      end
    end
  end
end
