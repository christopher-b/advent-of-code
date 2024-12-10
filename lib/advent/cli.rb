require "benchmark"
# require "benchmark/ips"
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

      # We do memory and time profiling in separate runs because the memory profiler significantly increases the execution time

      execution_time = ::Benchmark.realtime do
        puts Challenge.run(year:, day:)
      end
      puts ""
      puts "Execution time: #{(execution_time * 1000).round(2)}ms"

      memory_profile = MemoryProfiler.report do
        Challenge.run(year:, day:)
      end
      puts "Memory usage: #{(memory_profile.total_allocated_memsize.to_f / 1024 / 1024).round(2)}mb"
    end

    desc "init YEAR DAY", "Initialize a new day's challenge"
    def init(year, day)
      logger = ::Logger.new($stdout)
      Generator.new(year:, day:, logger:).call
    end

    desc "benchmark YEAR DAY", "Run the benchmark suite. If day is omitted, run all days"
    def benchmark(year, day = nil)
      Advent::Benchmark.new(year, day).run
      # Advent::Benchmark.new(year, day).stackprof
    end
  end
end
