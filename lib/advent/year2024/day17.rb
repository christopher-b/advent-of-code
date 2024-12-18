# https://adventofcode.com/2024/day/17
module Advent
  module Year2024
    class Day17 < Advent::Challenge
      # Part 1 was very simple. Part 2 was challenging but very interesting.
      # Help from https://www.youtube.com/watch?v=y-UPxMAh2N8

      def part1
        computer.run.output
      end

      def part2
        find(instructions, instructions[-1])
      end

      # This simulates the program
      # We start by running our code to determine what `a` would need to be to be to get the last answer
      # We recurse from there to find the fianl result
      def find(program, answer)
        return answer if program.empty?

        (0...8).each do |t|
          a = answer << 3 | t
          b = a % 8  # 2,4
          b ^= 1  # 1,1
          c = a >> b # 7,5
          b ^= 5  # 1,5
          b ^= c  # 4,1
          if b % 8 == program[-1]
            subanswer = find(program[...-1], a)
            next if subanswer.nil?
            return subanswer
          end
        end
        nil
      end

      def registers
        @registers ||= {}.tap do |registers|
          registers[:a] = input_lines[0].split(": ").last.to_i
          registers[:b] = input_lines[1].split(": ").last.to_i
          registers[:c] = input_lines[2].split(": ").last.to_i
        end
      end

      def instructions
        @instructions ||= input_lines[4].split(": ").last.split(",").map(&:to_i)
      end

      def computer
        @computer ||= Computer.new(registers, instructions)
      end

      class Computer
        attr_accessor :registers, :instructions, :instruction_pointer

        OPCODES = {
          0 => :adv,
          1 => :bxl,
          2 => :bst,
          3 => :jnz,
          4 => :bxc,
          5 => :out,
          6 => :bdv,
          7 => :cdv
        }

        def initialize(registers, instructions)
          @registers = registers
          @instructions = instructions
          @instruction_pointer = 0
          @output = []
        end

        def output
          @output.join(",")
        end

        def raw_output
          @output
        end

        def run
          max_run = 1000
          i = 0
          until instruction_pointer >= instructions.size
            raise "Too many instructions" if max_run < i += 1

            pointer_before = instruction_pointer # Check for jumpa

            opcode = instructions[instruction_pointer]
            operand = instructions[instruction_pointer + 1]

            send(OPCODES[opcode], operand)
            @instruction_pointer += 2 unless @instruction_pointer != pointer_before

          end

          self
        end

        def combo(operand)
          case operand
          when 0, 1, 2, 3 then operand
          when 4 then registers[:a]
          when 5 then registers[:b]
          when 6 then registers[:c]
          else raise "Invalid combo operand"
          end
        end

        # OPCODE 0
        def adv(operand) = registers[:a] = registers[:a] >> combo(operand)

        # OPCODE 1
        def bxl(operand) = registers[:b] ^= operand

        # OPCODE 2
        def bst(operand) = registers[:b] = combo(operand) % 8

        # OPCODE 3
        def jnz(operand) = (@instruction_pointer = operand unless registers[:a] == 0)

        # OPCODE 4
        def bxc(_operand) = registers[:b] ^= registers[:c]

        # OPCODE 5
        def out(operand) = @output << combo(operand) % 8

        # OPCODE 6
        def bdv(operand) = registers[:b] = registers[:a] >> combo(operand)

        # OPCODE 7
        def cdv(operand) = registers[:c] = registers[:a] >> combo(operand)
      end
    end
  end
end
