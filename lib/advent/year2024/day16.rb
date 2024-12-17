# https://adventofcode.com/2024/day/16
module Advent
  module Year2024
    class Day16 < Advent::Challenge
      # I flailed a lot with graph implementations before looking for help
      # With help from https://www.youtube.com/watch?v=BJhpteqlVPM

      def part1
        result.best_cost
      end

      def part2
        best_paths_size
      end

      def result
        @result ||= dijkstra_walk
      end

      def best_paths_size
        states = result.end_states.to_a
        seen = Set.new(result.end_states)

        until states.empty?
          state = states.shift
          result.backtrack[state].to_a.each do |last|
            next if seen.include?(last)
            seen << last
            states.push last
          end
        end

        seen.to_a.compact.map(&:position).uniq.size
      end

      def dijkstra_walk
        queue = PriorityQueue.new
        queue << Node.new(0, origin, nil)
        backtrack = Hash.new { |h, k| h[k] = Set.new }
        end_states = Set.new
        best_cost = Float::INFINITY
        lowest_cost = Hash.new(Float::INFINITY)
        lowest_cost[origin] = 0

        until queue.empty?
          node = queue.pop
          node => {cost:, current:, previous:} # Desctructuring!

          next if cost > lowest_cost[current]
          lowest_cost[current] = cost

          # return cost if current.position == finish
          if current.position == finish
            next if cost > best_cost
            best_cost = cost
            end_states << current
          end

          backtrack[current] << previous

          # Three possible moves: forward, turn left, turn right
          next_positions = [
            [cost + 1, current.step],
            [cost + 1000, current.rotate_clockwise],
            [cost + 1000, current.rotate_counter_clockwise]
          ]
          next_positions.each do |new_cost, next_vector|
            next if walls[next_vector.position]
            next if cost > lowest_cost[next_vector]
            queue << Node.new(new_cost, next_vector, current)
          end
        end

        Result.new(best_cost, backtrack, end_states)
      end

      Result = Data.define(:best_cost, :backtrack, :end_states)

      Node = Data.define(:cost, :current, :previous) do
        include Comparable
        def <=>(other) = other.cost <=> cost
      end

      def origin
        @origin ||= grid.each_char
          .find { |char, x, y| char == "S" }
          .then { |_, x, y| Vector.new(Point.new(x, y), Point::E) }
      end

      def finish
        @finish ||= grid.each_char
          .find { |char, x, y| char == "E" }
          .then { |_, x, y| Point.new(x, y) }
      end

      def walls
        @walls ||= grid.each_char
          .select { |char, _, _| char == "#" }
          .map { |_, x, y| wall = Point.new(x, y), [wall, wall] }
          .to_h
      end

      def grid
        @grid ||= Grid.new(input_lines)
      end
    end
  end
end
