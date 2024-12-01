$LOAD_PATH.unshift(File.dirname(__FILE__))

require "advent/cli"
require "advent/challenge"
require "advent/day_info"
require "advent/generator"

module Advent
  def self.pad_day(day)
    day.to_s.rjust(2, "0")
  end

  module Year2024
    (1..25).each do |day|
      day = Advent.pad_day(day)
      autoload :"Day#{day}", "advent/year2024/day#{day}"
    end
  end
end
