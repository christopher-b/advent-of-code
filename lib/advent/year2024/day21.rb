# https://adventofcode.com/2024/day/21
module Advent
  module Year2024
    class Day21 < Advent::Challenge
      # Explanation here

      def initialize(...)
        super
        @cache = {}
      end

      def part1
        do_chain(2).sum
      end

      def part2
        num_keypad = [
          ["7", "8", "9"],
          ["4", "5", "6"],
          ["1", "2", "3"],
          [nil, "0", "A"]
        ]
        dir_keypad = [
          [nil, "^", "A"],
          ["<", "v", ">"]
        ]

        num_seqs = compute_seqs(num_keypad)
        @dir_seqs = compute_seqs(dir_keypad)

        # dir_lengths = {key: len(value[0]) for key, value in dir_seqs.items()}
        @dir_lengths = @dir_seqs.transform_values { |value| value[0].length }

        total = 0
        codes.each do |code|
          line = code.join
          inputs = solve(line, num_seqs)
          length = inputs.map { |input| compute_length(input) }.min
          total += length * int(line[..-1])
        end

        total
      end

      def solve(string, seqs)
        combos = ("A" + string[..-2]).chars.zip(string.chars)
        options = combos.map { |x, y| seqs[[x, y]] }
        options.shift.product(*options).map(&:join)
      end

      def compute_length(seq, depth = 25, memo = {})
        memo_key = [seq, depth]
        return memo[memo_key] if memo.key?(memo_key)

        if depth == 1
          length = ("A" + seq).chars.zip(seq.chars).sum do |x, y|
            @dir_lengths[[x, y]]
          end
          memo[memo_key] = length
          return length
        end

        length = ("A" + seq).chars.zip(seq.chars).sum do |x, y|
          @dir_seqs[[x, y]].map { |subseq| compute_length(subseq, depth - 1, memo) }.min
        end

        memo[memo_key] = length
        length
      end

      def compute_seqs(keypad)
        pos = {}
        keypad.each_with_index do |row, r|
          row.each_with_index do |val, c|
            pos[val] = [r, c] unless val.nil?
          end
        end

        seqs = {}
        pos.each_key do |x|
          pos.each_key do |y|
            if x == y
              seqs[[x, y]] = ["A"]
              next
            end

            possibilities = []
            queue = [[[pos[x][0], pos[x][1]], ""]]
            optimal = Float::INFINITY

            until queue.empty?
              (r, c), moves = queue.shift
              directions = [
                [r - 1, c, "^"], [r + 1, c, "v"],
                [r, c - 1, "<"], [r, c + 1, ">"]
              ]

              break_outer = false
              directions.each do |nr, nc, nm|
                next if nr < 0 || nc < 0 || nr >= keypad.length || nc >= keypad[0].length
                next if keypad[nr][nc].nil?

                if keypad[nr][nc] == y
                  if optimal < moves.length + 1
                    break_outer = true
                    break
                  end
                  optimal = moves.length + 1
                  possibilities << moves + nm + "A"
                else
                  queue << [[nr, nc], moves + nm]
                end
              end
              break if break_outer
            end

            seqs[[x, y]] = possibilities
          end
        end
        seqs
      end

      # def compute_sequences(keypad)
      #   positions = Hash.new { |h, k| h[k] = {} }
      #   sequences = {}
      #   keypad.size.times do |r|
      #     keypad[0].size.times do |c|
      #       unless keypad[r][c].nil?
      #         positions[r][c] = [r, c]
      #       end
      #     end
      #   end
      #
      #       pp positions
      #   positions.values.each do |x|
      #     x.values.each do |y|
      #       if x == y
      #         sequences[[x, y]] = ["A"]
      #         next
      #       end
      #
      #
      #
      #       possibilites = []
      #       queue = []
      #       queue << [positions[x], ""]
      #       optimal = Float::INFINITY
      #       until queue.empty?
      #         (r, c), moves = queue.shift
      #         # pp r, c, moves
      #
      #       end
      #     end
      #   end
      # end

      def get_presses(x, y, depth)
        # return @cache[[x, y, depth]] if @cache[[x, y, depth]]
        return @cache[[x, y]] if @cache[[x, y]]

        # puts "computing at depth: #{depth} for #{x} to #{y}"

        pad = Keypad.new(x)
        presses = pad.presses_for(y)

        if depth == 1
          @cache[[x, y, depth]] = presses
          presses
        else
          current = "A"
          result = presses.each_with_object([]) do |button, ps|
            ps.concat(get_presses(current, button, depth - 1)).flatten
            current = button
          end
          @cache[[x, y, depth]] = result
          result
        end
      end

      def do_chain(chain_count)
        numpad = Numpad.new
        codes.map do |code|
          # puts "CODE: #{code}"
          presses = code.reduce([]) do |ps, button|
            ps.concat(numpad.presses_for(button)).flatten
          end

          current = "A"
          presses = presses.each_with_object([]) do |button, ps|
            ps.concat get_presses(current, button, chain_count)
            current = button
          end

          presses.size * code.join.to_i
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

        def initialize(cur = "A")
          @current = cur
        end

        def presses_for(button)
          return ["A"] if button == current

          graph = self.class.const_get(:GRAPH)
          presses = graph[current][button].chars
          @current = button
          presses << "A"
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
