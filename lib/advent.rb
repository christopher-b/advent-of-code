$LOAD_PATH.unshift(File.dirname(__FILE__))

require "debug"
require "advent/benchmark"
require "advent/cli"
require "advent/challenge"
require "advent/day_info"
require "advent/generator"

# Helper classes
require "advent/cursor"
require "advent/graph"
require "advent/grid"
require "advent/math"
require "advent/point"
require "advent/priority_queue"
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

  module Year2025
    (1..12).each do |day|
      day = Advent.pad_day(day)
      autoload :"Day#{day}", "advent/year2025/day#{day}"
    end
  end

  module Year2099
    class Day01 < Challenge; end
  end
end
