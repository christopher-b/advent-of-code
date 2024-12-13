# https://adventofcode.com/2023/day/07
module Advent
  module Year2023
    class Day07 < Advent::Challenge
      def call
        puts "Part 1: #{part1}"
        puts "Part 2: #{part2}"
      end

      def part1
        hands.sort.each_with_index.sum do |hand, i|
          hand.winnings(i + 1)
        end
      end

      def part2
        hands_js_are_jokers.sort.each_with_index.sum do |hand, i|
          hand.winnings(i + 1)
        end
      end

      def hands
        @hands ||= input_lines.map { |line| Hand.new(line) }
      end

      def hands_js_are_jokers
        @hands_js_are_jokers ||= input_lines.map { |line| Hand.new(line, js_are_jokers: true) }
      end

      class Hand
        attr_accessor :cards, :bid, :js_are_jokers

        CARDS = %w[2 3 4 5 6 7 8 9 T J Q K A]
        CARDS_WITH_JOKERS = %w[J 2 3 4 5 6 7 8 9 T Q K A]
        SIGNATURE_MAP = [
          [1, 1, 1, 1, 1], # High Card
          [1, 1, 1, 2],    # One Pair
          [1, 2, 2],       # Two pair
          [1, 1, 3],       # Three of a kind
          [2, 3],          # Full house
          [1, 4],          # Four of a kind
          [5]              # Five of a kind
        ]
        JOKER_MATRIX = [
          [0, 1, nil,	nil,	nil,	nil],
          [1, 3, 3, nil,	nil,	nil],
          [2, 4, 5, nil,	nil,	nil],
          [3, 5, nil,	5, nil,	nil],
          [4, nil,	6, 6, nil,	nil],
          [5, 6, nil,	nil,	6, nil],
          [6, 6, 6, 6, 6, 6]
        ]

        def initialize(line, js_are_jokers: false)
          @cards, @bid = line.split
          @bid = @bid.to_i
          @js_are_jokers = js_are_jokers
        end

        def winnings(rank)
          bid * rank
        end

        def score
          @score ||= begin
            # Represent cards as a hexadecimal numeric string
            # 29TJJ becomes 29abb
            card_ranks = js_are_jokers ? CARDS_WITH_JOKERS : CARDS
            base = cards.chars
              .map { |card| card_ranks.index card }
              .map { |i| i.to_s(16) }
              .join

            # Convert the hex string to an integer
            pre = prefix
            pre = apply_joker_matrix(pre) if js_are_jokers
            (pre.to_s + base).to_i(16)
          end
        end

        def prefix
          # Add a signature prefix so better hands have a higher leading number
          SIGNATURE_MAP.index(signature)
        end

        # Oops. I should have just repaced the Js with the most frequent letter
        def apply_joker_matrix(sig)
          # Modify hand type based on number of jokers
          JOKER_MATRIX[sig][j_count]
        end

        def j_count
          cards.count "J"
        end

        def signature
          # Determine number of occurances of unique characters
          @signature ||= @cards.chars
            .group_by { |label| label }
            .values
            .map(&:size)
            .sort
        end

        def <=>(other)
          score <=> other.score
        end
      end
    end
  end
end
