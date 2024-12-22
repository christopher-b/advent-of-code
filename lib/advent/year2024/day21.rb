# https://adventofcode.com/2024/day/21
module Advent
  module Year2024
    class Day21 < Advent::Challenge
      # Explanation here

      def part1
        do_chain(2)
      end

      def part2
        do_chain(25)
      end

      def do_chain(chain_count)
        numpad = Numpad.new
        keypads = []
        chain_count.times do
          keypads << Keypad.new
        end

        codes.sum do |code|
          puts "code: #{code}"
          presses = code.reduce([]) do |ps, button|
            ps.concat(numpad.presses_for(button)).flatten
          end

          keypads.each do |keypad|
            puts "keypad: #{keypads.index(keypad)}"
            presses = presses.reduce([]) do |ps, button|
              ps.concat(keypad.presses_for(button)).flatten
            end
          end

          presses.size * code.join.to_i

          # keypad1_presses = code.reduce([]) do |presses, button|
          #   presses.concat(numpad.presses_for(button)).flatten
          # end
          #
          # keypad2_presses = keypad1_presses.reduce([]) do |presses, button|
          #   presses.concat(keypad1.presses_for(button)).flatten
          # end
          #
          # keypad3_presses = keypad2_presses.reduce([]) do |presses, button|
          #   presses.concat(keypad2.presses_for(button)).flatten
          # end
          # keypad3_presses.size * code.join.to_i
        end
      end

      def codes
        @codes ||= input_lines.map(&:chars).map do |line|
          line[0..2].map(&:to_i) << "A"
        end
      end

      class Pad
        attr_accessor :graph, :current
        GRAPH = {}

        def initialize
          # @graph = Graph.new
          @current = "A"
          # initialize_graph
        end

        def presses_for(button)
          return ["A"] if button == current

          graph = self.class.const_get(:GRAPH)
          presses = graph[current][button].chars
          @current = button
          presses << "A"

          # [].tap do |presses|
          #   path = @graph.bfs_paths(current, button)
          #   raise "No path found for #{current}, #{button}" if path.nil?
          #   path.each_cons(2).map do |a, b|
          #     presses.push @graph.edge_weight(a, b)
          #   end
          #   presses.sort!
          #   presses << "A"
          #
          #   @current = button
          # end
        end
      end

      class Keypad < Pad
        GRAPH = {
          "A" => {
            "^" => "<",
            "<" => "<<v",
            # "<" => "v<<",
            "v" => "<v",
            # "v" => "v<",
            ">" => "v"
          },
          "^" => {
            "A" => ">",
            # "<" => "v<",
            "<" => "<v",
            "v" => "v",
            # ">" => ">v"
            ">" => "v>"
          },
          "v" => {
            "A" => "^>",
            # "A" => ">^",
            "<" => "<",
            "^" => "^",
            ">" => ">"
          },
          "<" => {
            # "A" => ">>^",
            "A" => "^>>",
            "v" => ">",
            # "^" => ">^",
            "^" => "^>",
            ">" => ">>"
          },
          ">" => {
            "A" => "^",
            "<" => "<<",
            # "^" => "^<",
            "^" => "<^",
            "v" => "<"
          }
        }

        # graph.add_edge("A", ">", "v")
        # graph.add_edge("A", "^", "<")
        # graph.add_edge("^", "v", "v")
        # graph.add_edge("v", "^", "^")
        # graph.add_edge(">", "A", "^")
        # graph.add_edge("^", "A", ">")
        # graph.add_edge("<", "v", ">")
        # graph.add_edge("v", "<", "<")
        # graph.add_edge("v", ">", ">")
        # graph.add_edge(">", "v", "<")
      end

      class Numpad < Pad
        A = "A"
        GRAPH = {
          A => {
            0 => "<",
            1 => "^<<",
            # 1 => "<<^",
            2 => "^<",
            # 2 => "<^",
            3 => "^",
            4 => "^^<<",
            # 4 => "<<^^",
            5 => "^^<",
            # 5 => "<^^",
            6 => "^^",
            7 => "^^^<<",
            # 7 => "<<^^^",
            8 => "^^^<",
            # 8 => "<^^^",
            9 => "^^^"
          },
          0 => {
            A => ">",
            # 1 => "^<",
            1 => "<^",
            2 => "^",
            3 => "^>",
            # 3 => ">^",
            # 4 => "^^<",
            4 => "<^^",
            5 => "^^",
            6 => "^^>",
            # 6 => ">^^",
            # 7 => "^^^<",
            7 => "<^^^",
            8 => "^^^",
            9 => "^^^>"
            # 9 => ">^^^"
          },
          1 => {
            # A => ">>v",
            A => "v>>",
            # 0 => ">v",
            0 => "v>",
            2 => ">",
            3 => ">>",
            4 => "^",
            5 => "^>",
            # 5 => ">^",
            6 => "^>>",
            # 6 => ">>^",
            7 => "^^",
            8 => "^^>",
            # 8 => ">^^",
            9 => "^^>>"
            # 9 => ">>^^"
          },
          2 => {
            # A => ">v",
            A => "v>",
            0 => "v",
            1 => "<",
            3 => ">",
            4 => "<^",
            # 4 => "^<",
            5 => "^",
            6 => "^>",
            # 6 => ">^",
            # 7 => "^^<",
            7 => "<^^",
            8 => "^^",
            # 9 => "^^>"
            9 => ">^^"
          },
          3 => {
            A => "v",
            # 0 => "v<",
            0 => "<v",
            1 => "<<",
            2 => "<",
            # 4 => "^<<",
            4 => "<<^",
            # 5 => "^<",
            5 => "<^",
            6 => "^",
            # 7 => "^^<<",
            7 => "<<^^",
            # 8 => "^^<",
            8 => "<^^",
            9 => "^^"
          },
          4 => {
            # A => ">>vv",
            A => "vv>>",
            # 0 => ">vv",
            0 => "vv>",
            1 => "v",
            2 => "v>",
            3 => "v>>",
            5 => ">",
            6 => ">>",
            7 => "^",
            8 => "^>",
            9 => "^>>"
          },
          5 => {
            A => "vv>",
            0 => "vv",
            1 => "<v",
            2 => "v",
            3 => "v>",
            4 => "<",
            6 => ">",
            7 => "<^",
            8 => "^",
            9 => "^>"
          },
          6 => {
            A => "vv",
            0 => "<vv",
            1 => "<<v",
            2 => "<v",
            3 => "v",
            4 => "<<",
            5 => "<",
            7 => "<<^",
            8 => "<^",
            9 => "^"
          },
          7 => {
            A => "vvv>>",
            0 => "vvv>",
            1 => "vv",
            2 => "vv>",
            3 => "vv>>",
            4 => "v",
            5 => "v>",
            6 => "v>>",
            8 => ">",
            9 => ">>"
          },
          8 => {
            A => "vvv>",
            0 => "vvv",
            1 => "<vv",
            2 => "vv",
            3 => "vv>",
            4 => "<v",
            5 => "v",
            6 => "v>",
            7 => "<",
            9 => ">"
          },
          9 => {
            A => "vvv",
            0 => "<vvv",
            1 => "<<vv",
            2 => "<vv",
            3 => "vv",
            4 => "<<v",
            5 => "<v",
            6 => "v",
            7 => "<<",
            8 => "<"
          }
        }

        # def initialize_graph
        # graph.add_node("A")
        # (0..9).each { |i| graph.add_node(i) }

        # graph.add_edge("A", 3, "^")
        # graph.add_edge("A", 0, "<")
        # graph.add_edge(0, 2, "^")
        # graph.add_edge(0, "A", ">")
        # graph.add_edge(1, 4, "^")
        # graph.add_edge(1, 2, ">")
        # graph.add_edge(2, 5, "^")
        # graph.add_edge(2, 1, "<")
        # graph.add_edge(2, 3, ">")
        # graph.add_edge(2, 0, "v")
        # graph.add_edge(3, "A", "v")
        # graph.add_edge(3, 2, "<")
        # graph.add_edge(3, 6, "^")
        # graph.add_edge(4, 1, "v")
        # graph.add_edge(4, 7, "^")
        # graph.add_edge(4, 5, ">")
        # graph.add_edge(5, 2, "v")
        # graph.add_edge(5, 8, "^")
        # graph.add_edge(5, 4, "<")
        # graph.add_edge(5, 6, ">")
        # graph.add_edge(6, 3, "v")
        # graph.add_edge(6, 9, "^")
        # graph.add_edge(6, 5, "<")
        # graph.add_edge(7, 4, "v")
        # graph.add_edge(7, 8, ">")
        # graph.add_edge(8, 5, "v")
        # graph.add_edge(8, 7, "<")
        # graph.add_edge(8, 9, ">")
        # graph.add_edge(9, 6, "v")
        # graph.add_edge(9, 8, "<")
        # end
      end
    end
  end
end
