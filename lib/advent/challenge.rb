module Advent
  class Challenge
    attr_reader :input_file

    def initialize(input_file)
      @input_file = input_file
    end

    def call
      raise NotImplementedError
    end

    def each_line(...)
      @input_file.each_line(...)
    end

    def lines
      @input_file.readlines(chomp: true)
    end
  end
end
