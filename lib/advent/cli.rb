require "benchmark"
require "memory_profiler"
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
      memory_profile = nil
      execution_time = Benchmark.realtime do
        memory_profile = MemoryProfiler.report do
          Challenge.run(year:, day:)
        end
      end

      puts "Execution time: #{(execution_time * 1000).round(2)}ms"
      puts "Memory usage: #{(memory_profile.total_allocated_memsize.to_f / 1024 / 1024).round(2)}mb"
    end

    desc "init YEAR DAY", "Initialize a new day's challenge"
    def init(year, day)
      logger = ::Logger.new($stdout)
      Generator.new(year:, day:, logger:).call
    end
  end
end
