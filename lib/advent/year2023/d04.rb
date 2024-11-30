#!/usr/bin/env ruby
require_relative "advent"

class Advent
  class Day4 < Day
    def start
      @cards = {}
      @sum = 0

      parse_file

      @cards.values.each { |card| check_card(card) }

      puts "Part 1: #{@cards.values.map(&:score).sum}"
      puts "Part 2: #{@sum}"
    end

    def parse_file
      each_line do |line|
        parts = line.split(/:|\|/)

        winning_numbers = parts[1].split(" ").map(&:to_i)
        my_numbers = parts[2].split(" ").map(&:to_i)
        index = parts[0].match(/\d+/)[0].to_i

        @cards[index] = Card.new(winning_numbers, my_numbers, index)
      end
    end

    def check_card(card)
      @sum += 1

      return if card.match_count.zero?

      card.matches.each do |match|
        check_card(@cards[match])
      end
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

Advent::Day4.new("./input04.txt").start
