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
        # Z-gates are the output result bits. They should all be the same, except the last one which has different behavior.
        # Inspection reveals that this should be an XOR, but there are outlies:
        # z15: OR
        # z23: AND
        # z39: AND
        #
        # Go one level deeper, we should have input gates that are either OR or XOR
        # z00: x00 (nil) y00 (nil)
        # z01: wbd (AND) dqq (XOR) (wbd is baddy?)
        # z05: rgq (OR) svm (AND) (rgq is baddy?)
        # z15: dkk(AND) pbd (AND) (both bad, but we think z15 is bad so these may be right?)
        # z16: kqk: (XOR) rbr (XOR) (either could be bad?)
        # z23: x23 (nil) y23 (nil) ??
        #
        # Next level, we should have two nil operations and two ANDs
        # ?? z01: nil * 4
        # z06:
        #   pdf/nbc: XOR
        # ?? z15:
        # ?? z16:
        # z24:
        #   ngq/cqg: XOR
        #
        # z15, z23, z39, wbd, rgq, (kqk || rbr), nbc, cqg
        #
        # ?? (dkk || pbd)

        swaps = []
        4.times do
          baseline = progress
          x_memo = y_memo = nil
          gates.values.each do |x|
            gates.values.each do |y|
              next if x == y
              next unless x.inputs && y.inputs

              swap_gates(x, y)
              if progress > baseline
                x_memo, y_memo = x, y
                break
              end
              swap_gates(x, y) # swap back
            end

            break if x_memo && y_memo
          end

          swaps << x_memo << y_memo if x_memo && y_memo
        end

        swaps.map(&:name).sort.join(",")
      end

      def swap_gates(x, y)
        # x.name, y.name = y.name, x.name
        x.inputs[0], y.inputs[0] = y.inputs[0], x.inputs[0]
        x.inputs[1], y.inputs[1] = y.inputs[1], x.inputs[1]
        x.operation, y.operation = y.operation, x.operation
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

      def verify_z(gate, num)
        x, y = gate.inputs
        return false unless gate.xor?
        return [x.name, y.name] == ["x00", "y00"] if num == 0

        (verify_intermediate_xor(x, num) && verify_carry_bit(y, num)) \
          || (verify_intermediate_xor(y, num) && verify_carry_bit(x, num))
      end

      def verify_intermediate_xor(gate, num)
        x, y = gate.inputs
        return false unless gate.xor?
        [x, y].map(&:name).sort == [gname("x", num), gname("y", num)]
      end

      def verify_carry_bit(gate, num)
        x, y = gate.inputs

        if num == 1
          return false if gate.operation != "AND"
          return [x, y].sort.map(&:name) == ["x00", "y00"]
        end

        return false unless gate.operation == "OR"
        (verify_direct_carry(x, num - 1) && verify_recarry(y, num - 1)) \
          || (verify_direct_carry(y, num - 1) && verify_recarry(x, num - 1))
      end

      def verify_direct_carry(gate, num)
        x, y = gate.inputs
        return false unless gate.operation == "AND"
        [x, y].sort.map(&:name) == [gname("x", num), gname("y", num)]
      end

      def verify_recarry(gate, num)
        x, y = gate.inputs
        return false unless gate.operation == "AND"

        (verify_intermediate_xor(x, num) && verify_carry_bit(y, num)) \
          || (verify_intermediate_xor(y, num) && verify_carry_bit(x, num))
      end

      def verify(num)
        name = "z#{num.to_s.rjust(2, "0")}"
        verify_z(gates[name], num)
      end

      def gname(char, num) = "#{char}#{num.to_s.rjust(2, "0")}"

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

        def xor? = operation == "XOR"

        def and? = operation == "AND"

        def or? = operation == "OR"

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
