require "tsort"

# https://adventofcode.com/2024/day/05
module Advent
  module Year2024
    class Day05 < Advent::Challenge
      # My inital solution involved indexing all rules by both digits, so we could
      # easily find a rule for a given pair by intersecting the values for each index.
      # Then we could compare the rule with the pair to determine a match.
      # This took about 250ms
      #
      # However, we can use a topological sort to determine the order of the pages.
      # The graph is not a DAG, so we can't just sort the whole batch. We sort subsets instead.
      # This takes about 11ms.

      attr_accessor :rules, :updates

      def call
        parse_input
        puts "Part 1: #{part1}"
        puts "Part 2: #{part2}"
      end

      def part1
        valid_updates.sum(&:middle)
      end

      def part2
        sorted_invalid_updates.sum(&:middle)
      end

      def valid_updates
        @valid_updates ||= updates.select(&:valid?)
      end

      def invalid_updates
        @invalid_updates ||= updates - valid_updates
      end

      def sorted_invalid_updates
        @sorted_invalid_updates ||= invalid_updates.each(&:sort!)
      end

      def parse_input
        @rules = []
        @updates = []
        raw_rules, raw_updates = input_text.split("\n\n")

        @rules = raw_rules.lines.map { |line| line.split("|").map(&:to_i) }
        @updates = raw_updates.lines.map { |line| Update.new(line.split(",").map(&:to_i)) }
        Update.graph = dependency_graph
      end

      # Each key contains a set of values that must come after
      def dependency_graph
        @dependency_graph ||= rules.each_with_object({}) do |(before, after), graph|
          graph[before] ||= Set.new
          graph[after] ||= Set.new
          graph[before] << after
        end
      end

      class Update
        include Enumerable
        include TSort

        attr_reader :pages

        def initialize(pages)
          @pages = pages
        end

        def middle
          pages[pages.length / 2]
        end

        def valid?
          pages.combination(2).none? do |page, later_page|
            Update.graph[later_page]&.include?(page)
          end
        end

        def each(&block)
          pages.each(&block)
        end

        def sort!
          @pages = tsort.reverse & pages
          self
        end

        def tsort_each_node(...)
          (Update.graph.keys & pages).each(...)
        end

        def tsort_each_child(node, &block)
          (Update.graph[node] & pages).each(&block)
        end

        class << self
          attr_accessor :graph
        end
      end
    end
  end
end
