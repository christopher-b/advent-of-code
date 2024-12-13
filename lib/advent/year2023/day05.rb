# https://adventofcode.com/2023/day/05
# This was a hard one (part 2). I got help from Claude.AI, but I only partially understand.
module Advent
  module Year2023
    class Day05 < Advent::Challenge
      attr_reader :seeds, :maps

      def part1
        seeds.map do |seed|
          maps.first.map(seed)
        end.min
      end

      def part2
        seed_ranges = seeds.each_slice(2).map do |first_seed, size|
          [first_seed, first_seed + size - 1]
        end

        current_ranges = seed_ranges
        maps.each do |map|
          current_ranges = map_ranges(current_ranges, map)
        end

        current_ranges.map(&:first).min
      end

      def parse_input
        seeds, *chunks = @input_file.read.split("\n\n")

        # Parse the first line into a list of seed values
        @seeds = seeds.scan(/\d+/).map(&:to_i)

        # Parse the remaining lines into maps
        @map_index = {}
        @maps = chunks.map do |chunk|
          chunk_lines = chunk.split("\n")
          title = chunk_lines.shift.split(/[-\s]/)
          ranges = chunk_lines.map do |line|
            Range.new(*line.split(" ").map(&:to_i))
          end
          @map_index[title[0]] = Map.new(
            src_name: title[0],
            dest_name: title[2],
            ranges: ranges,
            index: @map_index
          )
          @map_index[title[0]]
        end
      ensure
        @input_file.rewind
      end

      # The map_ranges method handles the complex logic of transforming ranges:
      #
      # It finds overlapping portions of ranges
      # Maps the overlapping portions to their destination ranges
      # Keeps track of unmapped portions of ranges
      # Ensures all input ranges are fully processed
      def map_ranges(input_ranges, map)
        # Where we'll store successfully mapped ranges
        result_ranges = []
        # A copy of input ranges that we'll progressively process
        unmapped_ranges = input_ranges.dup

        map.ranges.each do |range|
          next_unmapped_ranges = []

          # We iterate through each of our current unmapped input ranges
          unmapped_ranges.each do |start, end_point|
            source_start = range.source_start
            source_end = source_start + range.size - 1
            dest_start = range.dest_start

            # No overlap
            # We add the entire input range to next_unmapped_ranges
            # and skip to the next iteration
            if end_point < source_start || start > source_end
              next_unmapped_ranges << [start, end_point]
              next
            end

            # Partial or complete overlap
            # When there's an overlap:
            # Calculate the exact overlapping portion
            # Map this portion to the destination range
            # by adding the offset between source and destination starts
            overlap_start = [start, source_start].max
            overlap_end = [end_point, source_end].min

            # Map the overlapping portion
            mapped_start = overlap_start + (dest_start - source_start)
            mapped_end = overlap_end + (dest_start - source_start)
            # Add the mapped range to result_ranges
            result_ranges << [mapped_start, mapped_end]

            # Add any remaining unmapped portions
            # If the input range extends before the source range, add the unmapped prefix
            if start < source_start
              next_unmapped_ranges << [start, source_start - 1]
            end
            # If the input range extends after the source range, add the unmapped suffix
            if end_point > source_end
              next_unmapped_ranges << [source_end + 1, end_point]
            end
          end

          # At the end, add any completely unmapped ranges to the results
          unmapped_ranges = next_unmapped_ranges
        end

        # Add any remaining unmapped ranges
        result_ranges.concat(unmapped_ranges)
      end

      Map = Data.define(:src_name, :dest_name, :ranges, :index) do
        def map(input)
          dest = index[dest_name]
          dest ? dest.map(output(input)) : output(input)
        end

        def output(input)
          range = ranges.find { |range| range.contains(input) }
          range ? input + range.offset : input
        end

        def dest
          index[dest_name]
        end
      end

      Range = Data.define(:dest_start, :source_start, :size) do
        def contains(input)
          source_start <= input && input < source_start + size
        end

        def offset = dest_start - source_start
      end
    end
  end
end
