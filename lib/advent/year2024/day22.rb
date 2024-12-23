# https://adventofcode.com/2024/day/22
module Advent
  module Year2024
    class Day22 < Advent::Challenge
      # Not too hard. The first part is just apply the evolution function.
      # For part two, we check each item in each list. We keep a running list of the last four
      # deltas, then add the price if this is the first time we've seen this sequence. We can then
      # get the max if sums of those prices.

      def part1
        evolved_secrets.map(&:last).sum
      end

      def part2
        # Parsed prices: keys are sequences, values are hashes of secret list index => price

        indexed_prices = parsed_prices.values # {0=>6, 2=>4}
        raw_prices = indexed_prices.map(&:values)
        grouped_prices = raw_prices.map(&:sum)
        grouped_prices.max
      end

      def evolved_secrets
        @evolved_secrets ||= [].tap do |evolved_list|
          secrets.each do |secret|
            answer = secret
            this_list = [answer]
            2000.times do
              answer = evolve_secret(answer)
              this_list << answer
            end
            evolved_list << this_list
          end
        end
      end

      def parsed_prices
        @parsed_prices ||= Hash.new { |h, k| h[k] = {} }.tap do |price_map|
          evolved_secrets.each_with_index do |secret_list, i|
            last_four_deltas = []
            last_price = nil

            secret_list.each do |secret|
              price = secret % 10
              last_four_deltas << (price - last_price) if last_price
              last_four_deltas.shift if last_four_deltas.size > 4
              last_price = price

              next unless last_four_deltas.length == 4

              price_map[last_four_deltas.to_s][i] ||= price
            end
          end
        end
      end

      def evolve_secret(num)
        num = prune(mix(num, num * 64))
        num = prune(mix(num, num / 32))
        prune(mix(num, num * 2048))
      end

      def mix(a, b) = a ^ b

      def prune(num) = num % 16777216

      def secrets = @secrets ||= input_lines.map(&:to_i)
    end
  end
end
