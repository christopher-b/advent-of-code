# https://adventofcode.com/2024/day/09
module Advent
  module Year2024
    class Day09 < Advent::Challenge
      # My first approach didn't finish after an hour or so :\
      # This method tracks the positions and size of files as a list, but doesn't bother to sort them. We're just changing positions around.

      def part1
        disk_map.compact.checksum
      end

      def part2
        smart_disk_map.compact.checksum
      end

      def disk_map
        DiskMap.new(input_text)
      end

      def smart_disk_map
        SmartDiskMap.new(input_text)
      end

      class SmartDiskMap
        attr_accessor :files, :blanks, :file_id

        def initialize(input_text)
          @files = {}
          @blanks = []
          @file_id = 0

          position = 0
          # Parse into files and blanks
          input_text.chars.each_with_index do |char, i|
            size = char.to_i
            if i.even?
              files[file_id] = [position, size]
              @file_id += 1
            else
              blanks << [position, size] unless size.zero?
            end

            position += size
          end
        end

        def render
          files.each do |id, (position, size)|
            size.times { print id }
            _, blank_size = blanks.find { |(blank_position, blank_size)| blank_position > position }
            blank_size.&times { print "." }
          end
        end

        def compact
          while file_id > 0
            @file_id -= 1

            file_position, file_size = files[file_id]
            blanks.each_with_index do |(blank_position, blank_size), i|
              # If the blank is after the file, we can skip it and all previous blanks
              if blank_position >= file_position
                @blanks = @blanks[...i]
                break
              end

              if file_size <= blank_size
                files[file_id] = [blank_position, file_size]

                if file_size == blank_size
                  @blanks.delete_at(i)
                else
                  @blanks[i] = [blank_position + file_size, blank_size - file_size]
                end
                break
              end
            end
          end

          self
        end

        def checksum
          total = 0
          files.each do |id, (position, size)|
            (position...position + size).each do |x|
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
