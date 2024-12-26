# https://adventofcode.com/2024/day/24
module Advent
  module Year2024
    class Day24 < Advent::Challenge
      # Part one was quite simple with an OO approach.
      # I understood what kind of approach was required for part 2, but didn't have the time and brain power to track
      # down the offending gates. I used a brute force verification approach from https://www.youtube.com/watch?v=SU6lp6wyd3I
      #
      # Some of my earlier attempts at part two were very close!

      def part1
        z_vals = z_gates.map(&:value)
        z_vals.join.reverse.to_i(2)
      end

      def part2
        # Brute force. Try each swap and see if it furthers the progress.
        swaps = []
        4.times do
          baseline = progress
          x_memo = y_memo = nil # We need these to pull them out of the loop scope

          gates.values.each do |x|
            gates.values.each do |y|
              next if x == y
              next unless x.inputs && y.inputs

              x.swap(y)
              if progress > baseline
                x_memo, y_memo = x, y
                break
              end
              x.swap(y)
            end

            break if x_memo && y_memo
          end

          swaps << x_memo << y_memo if x_memo && y_memo
        end

        swaps.map(&:name).sort.join(",")
      end

      def z_gates
        gates.select { |k, _| k.start_with?("z") }.values.sort
      end

      def progress
        i = 0
        loop do
          break unless verify(i)
          i += 1
        end
        i
      end

      def verify(num)
        name = "z#{num.to_s.rjust(2, "0")}"
        gates[name].z?(num)
      end

      def pretty_print(gate, depth = 0)
        return "  " * depth + gate.name if gate.name.start_with?("x", "y")
        "  " * depth + "#{gate.operation} (#{gate.name})\n \
#{pretty_print(gate.inputs[0], depth + 1)}\n \
#{pretty_print(gate.inputs[1], depth + 1)}"
      end

      def gates
        @gates ||= Hash.new { |h, k| h[k] = Gate.new(k) }.tap do |gs|
          input_chunks[0].lines.each do |line|
            gate, value = line.split(": ")
            gs[gate].value = value.to_i
          end

          input_chunks[1].lines.each do |line|
            input1, operation, input2, _, gate = line.split
            gs[gate].inputs = [gs[input1], gs[input2]]
            gs[gate].operation = operation
          end
        end
      end

      class Gate
        include Comparable

        attr_accessor :name, :inputs, :operation
        attr_writer :value

        def initialize(name)
          @name = name
          @value = @inputs = @operation = nil
        end

        def <=>(other)
          name <=> other.name
        end

        def swap(other)
          @name, other.name = other.name, @name
          @inputs, other.inputs = other.inputs, @inputs
          @operation, other.operation = other.operation, @operation
        end

        def intermediate_xor?(num)
          return false unless xor?
          input_names == [gname("x", num), gname("y", num)]
        end

        def direct_carry?(num)
          return false unless and?
          input_names == [gname("x", num), gname("y", num)]
        end

        def carry_bit?(num)
          if num == 1
            return false unless and?
            return input_names == ["x00", "y00"]
          end

          return false unless or?

          (x.direct_carry?(num - 1) && y.recarry?(num - 1)) \
            || (y.direct_carry?(num - 1) && x.recarry?(num - 1))
        end

        def recarry?(num)
          return false unless and?

          (x.intermediate_xor?(num) && y.carry_bit?(num)) \
            || (y.intermediate_xor?(num) && x.carry_bit?(num))
        end

        def z?(num)
          return false unless xor?
          return input_names == ["x00", "y00"] if num == 0

          (x.intermediate_xor?(num) && y.carry_bit?(num)) \
            || (y.intermediate_xor?(num) && x.carry_bit?(num))
        end

        def input_names
          inputs.map(&:name).sort
        end

        def gname(char, num) = "#{char}#{num.to_s.rjust(2, "0")}"

        def xor? = operation == "XOR"

        def and? = operation == "AND"

        def or? = operation == "OR"

        def x = inputs[0]

        def y = inputs[1]

        def value
          return @value if @value

          if inputs
            @value = case operation
            when "AND" then inputs[0].value & inputs[1].value
            when "OR" then inputs[0].value | inputs[1].value
            when "XOR" then inputs[0].value ^ inputs[1].value
            end
          end
        end
      end
    end
  end
end
