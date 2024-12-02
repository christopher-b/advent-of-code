require "benchmark"
require "logger"
require "thor"

module Advent
  class Cli < Thor
    def self.exit_on_failure?
      true
    end

    desc "go YEAR DAY", "Run the challenge for the specified year and day"
    def go(year, day)
      puts "Running challenge for #{year} Day #{day}"
      execution_time = Benchmark.realtime do
        Challenge.run(year:, day:)
      end
      puts "Execution time: #{execution_time}s"
    end

    desc "init YEAR DAY", "Initialize a new day's challenge"
    def init(year, day)
      logger = ::Logger.new($stdout)
      Generator.new(year:, day:, logger:).call
    end
  end
end
