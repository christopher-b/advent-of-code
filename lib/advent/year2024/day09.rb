# https://adventofcode.com/2024/day/09
module Advent
  module Year2024
    class Day09 < Advent::Challenge
      # My first approach didn't finish after an hour or so :\
      # This method tracks the positions and size of files as a list, but doesn't bother to sort them. We're just changing positions around.
      # This completes in about 125ms

      def part1
        DiskMap.new(input_text).compact.checksum
      end

      def part2
        SmartDiskMap.new(input_text).compact.checksum
      end

      class SmartDiskMap
        attr_accessor :files, :blanks

        File = Data.define(:position, :size)

        def initialize(input_text)
          @files = {}
          @blanks = []
          parse_input(input_text)
        end

        # Parse into files and blanks
        def parse_input(input_text)
          file_id = position = 0

          input_text.chars.map(&:to_i).each_with_index do |size, i|
            if i.even?
              files[file_id] = File.new(position:, size:)
              file_id += 1
            else
              blanks << File.new(position:, size:) unless size.zero?
            end

            position += size
          end
        end

        def render
          files.each do |id, file|
            size.times { print id }
            blank = blanks.find { |blank| blank.position > file.position }
            blank.size.&times { print "." }
          end
        end

        def compact
          files.keys.reverse_each do |file_id|
            file = files[file_id]
            blanks.each_with_index do |blank, i|
              # If the blank is after the file, we can skip it and all previous blanks
              if blank.position >= file.position
                @blanks = @blanks[...i]
                break
              end

              # If we can squeeze the file into the blank
              if file.size <= blank.size
                files[file_id] = File.new(position: blank.position, size: file.size)

                if file.size == blank.size
                  @blanks.delete_at(i)
                else
                  @blanks[i] = File.new(position: blank.position + file.size, size: blank.size - file.size)
                end

                break
              end
            end
          end

          self
        end

        def checksum
          total = 0
          files.each do |id, file|
            (file.position...file.position + file.size).each do |x|
              total += id * x
            end
          end
          total
        end
      end

      class DiskMap
        attr_reader :files

        def initialize(input_text)
          @files = []

          file_id = -1
          input_text.chars.each_with_index do |char, i|
            size = char.to_i
            if i.even?
              @files.concat [file_id += 1] * size
            else
              @files.concat [-1] * size
            end
          end
        end

        def checksum
          files.each_with_index.sum { |file, i| file * i }
        end

        def blank_indicies
          files.each_index.select { |i| files[i] == -1 }
        end

        def compact
          blank_indicies.each do |blank_index|
            while files[-1] == -1
              files.pop
            end

            break if files.size <= blank_index
            files[blank_index] = files.pop
          end

          self
        end
      end
    end
  end
end
