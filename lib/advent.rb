$LOAD_PATH.unshift(File.dirname(__FILE__))

require "advent/benchmark"
require "advent/cli"
require "advent/challenge"
require "advent/day_info"
require "advent/generator"

# Helper classes
require "advent/cursor"
require "advent/grid"
require "advent/point"
require "advent/vector"

module Advent
  def self.pad_day(day)
    day.to_s.rjust(2, "0")
  end

  module Year2023
    (1..25).each do |day|
      day = Advent.pad_day(day)
      autoload :"Day#{day}", "advent/year2023/day#{day}"
    end
  end

  module Year2024
    (1..25).each do |day|
      day = Advent.pad_day(day)
      autoload :"Day#{day}", "advent/year2024/day#{day}"
    end
  end

  module Year2099
    class Day01 < Challenge; end
  end
end
