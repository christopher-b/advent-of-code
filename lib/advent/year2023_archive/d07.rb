#!/usr/bin/env ruby
require "./advent"

class Advent
  class Day7 < Day
    def start
      parse_file
      puts part_1
      puts part_2
    end

    def part_1
      total = 0
      @hands.sort.each_with_index do |hand, i|
        total += hand.winnings(i + 1)
      end
      total
    end

    def part_2
      total = 0
      @hands.each { |h| h.js_are_jokers = true }
      @hands.sort.each_with_index do |hand, i|
        total += hand.winnings(i + 1)
      end
      total
    end

    def parse_file
      @hands = each_line.map { |line| Hand.new(line) }
    end
  end

  class Hand
    attr_accessor :cards, :bid, :js_are_jokers
    # CARDS = %s(A K Q J T 9 8 7 6 5 4 3 2)
    CARDS = %w[2 3 4 5 6 7 8 9 T J Q K A]
    CARDS_WITH_JOKERS = %w[J 2 3 4 5 6 7 8 9 T Q K A]

    def initialize(line)
      @cards, @bid = line.split " "
      @bid = @bid.to_i
      @js_are_jokers = false
    end

    def winnings(rank)
      @bid * rank
    end

    def score
      @score ||= begin
        # Represent cards as a hexadecimal numeric string
        # 29TJJ becomes 29abb
        card_ranks = js_are_jokers ? CARDS_WITH_JOKERS : CARDS
        base = @cards.chars
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
      signature_map = [
        [1, 1, 1, 1, 1], # High Card
        [1, 1, 1, 2], # One Pair
        [1, 2, 2], # Two pair
        [1, 1, 3], # Three of a kind
        [2, 3], # Full house
        [1, 4], # Four of a kind
        [5] # Five of a kind
      ]

      signature_map.index(signature)
    end

    # Oops. I should have just repaced the Js with the most frequent letter
    def apply_joker_matrix(sig)
      # Modify hand type based on number of jokers
      mod_matrix = [
        [0, 1, nil,	nil,	nil,	nil],
        [1, 3, 3, nil,	nil,	nil],
        [2, 4, 5, nil,	nil,	nil],
        [3, 5, nil,	5, nil,	nil],
        [4, nil,	6, 6, nil,	nil],
        [5, 6, nil,	nil,	6, nil],
        [6, 6, 6, 6, 6, 6]
      ]

      mod_matrix[sig][j_count]
    end

    def j_count
      @cards.count "J"
    end

    def signature
      # Determine number of occurances of unique characters
      @signature ||= @cards.chars.group_by { |label| label }.values.map(&:size).sort
    end

    def <=>(other)
      score <=> other.score
    end
  end
end

Advent::Day7.new("./input07.txt").start
