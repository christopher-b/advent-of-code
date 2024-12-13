# https://adventofcode.com/2023/day/04
module Advent
  module Year2023
    class Day04 < Advent::Challenge
      def call
        puts "Part 1: #{part1}"
        puts "Part 2: #{part2}"
      end

      def part1
        cards.map(&:score).sum
      end

      def part2
        cards.each { |card| check_card(card) }
        @sum
      end

      def cards
        @cards ||= input_lines.map do |line|
          parts = line.split(/:|\|/)

          winning_numbers = parts[1].split(" ").map(&:to_i)
          my_numbers = parts[2].split(" ").map(&:to_i)
          index = parts[0].match(/\d+/)[0].to_i

          Card.new(winning_numbers, my_numbers, index)
        end
      end

      # @TODO - This is a recursive function, it can be optimized
      def check_card(card)
        @sum ||= 0
        @sum += 1

        return if card.match_count.zero?

        card.matches.each do |match|
          check_card(card_by_index(match))
        end
      end

      def card_by_index(index)
        @card_index ||= cards.map { |card| [card.index, card] }.to_h
        @card_index[index]
      end

      class Card
        attr_reader :index
        def initialize(winning_numbers, my_numbers, index)
          @winning_numbers = winning_numbers
          @my_numbers = my_numbers
          @index = index
        end

        def match_count
          (@my_numbers & @winning_numbers).size
        end

        def matches
          return [] if match_count.zero?

          (index + 1)..(index + match_count)
        end

        def score
          return 0 if match_count.zero?
          2**(match_count - 1)
        end
      end
    end
  end
end
