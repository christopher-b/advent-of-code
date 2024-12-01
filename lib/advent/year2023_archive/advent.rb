class Advent
  class Day
    def initialize(input_file)
      @input_file = input_file
    end

    def file
      File.read(@input_file)
    end

    def each_line
      lines = File.readlines(@input_file, chomp: true)
      if block_given?
        i = 0
        lines.each do |line|
          yield line, i
          i += 1
        end
      else
        lines
      end
    end
  end
end
