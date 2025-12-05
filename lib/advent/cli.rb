require "benchmark"
require "memory_profiler"
require "logger"
require "thor"

module Advent
  # Command-line interface for Advent of Code challenges.
  # Provides commands to run, initialize, and benchmark challenge solutions.
  #
  # @example Running a challenge
  #   advent go 2024 1
  #
  # @example Initializing a new day
  #   advent init 2024 25
  #
  # @example Running benchmarks
  #   advent benchmark 2024 1
  class Cli < Thor
    # Configures Thor to exit with failure status on errors.
    #
    # @return [Boolean] Always returns true
    def self.exit_on_failure?
      true
    end

    desc "go YEAR DAY", "Run the challenge for the specified year and day"
    # Runs the challenge for the specified year and day with execution time profiling.
    # Outputs the results of both parts along with the total execution time in milliseconds.
    #
    # @param year [String] The year of the challenge (e.g., "2024")
    # @param day [String] The day of the challenge (1-25)
    # @return [true]
    def go(year, day)
      puts "Running challenge for #{year} Day #{day}"

      execution_time = ::Benchmark.realtime do
        puts Challenge.run(year:, day:)
      end
      puts ""
      puts "Execution time: #{(execution_time * 1000).round(2)}ms"

      true
    end

    desc "init YEAR DAY", "Initialize a new day's challenge"
    # Initializes a new day's challenge by generating template files.
    # Creates the necessary challenge and test files for the specified year and day.
    #
    # @param year [String] The year of the challenge (e.g., "2024")
    # @param day [String] The day of the challenge (1-25)
    # @return [true]
    def init(year, day)
      logger = ::Logger.new($stdout)
      Generator.new(year:, day:, logger:).call
      true
    end

    desc "benchmark YEAR DAY", "Run the benchmark suite. If day is omitted, run all days"
    # Runs performance benchmarks using stackprof for the specified challenge.
    # If day is omitted, benchmarks all days for the given year.
    #
    # @param year [String] The year of the challenge (e.g., "2024")
    # @param day [String, nil] The day of the challenge (1-25), or nil to benchmark all days
    # @return [true]
    def benchmark(year, day = nil)
      Advent::Benchmark.new(year, day).stackprof
      true
    end
  end
end
