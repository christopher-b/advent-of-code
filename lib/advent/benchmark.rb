require "stackprof"

module Advent
  # Performance benchmarking utilities for Advent of Code challenges.
  # Supports both time benchmarking and CPU profiling with StackProf.
  #
  # @example Benchmarking a specific day
  #   benchmark = Benchmark.new(2024, 1)
  #   benchmark.run
  #
  # @example Benchmarking all days in a year
  #   benchmark = Benchmark.new(2024)
  #   benchmark.run
  #
  # @example Profiling with StackProf
  #   benchmark = Benchmark.new(2024, 1)
  #   benchmark.stackprof
  #   # Generates tmp/stackprof-wall-2024-1.dump
  class Benchmark
    # Value object containing benchmark results.
    #
    # @!attribute [r] average
    #   @return [Float] Average execution time in seconds
    # @!attribute [r] times
    #   @return [Array<Float>] Individual execution times in seconds
    # @!attribute [r] standard_deviation
    #   @return [Float] Standard deviation of execution times
    Result = Data.define(:average, :times, :standard_deviation)

    # Creates a new Benchmark instance.
    #
    # @param year [Integer, String] The year to benchmark
    # @param day [Integer, String, nil] The specific day to benchmark, or nil for all days
    def initialize(year, day = nil)
      @year = year
      @day = day
    end

    # Runs benchmarks for the specified day(s).
    # Executes each challenge multiple times and reports average execution time.
    #
    # @return [void]
    def run
      puts "Running benchmarks..."
      days.each do |day|
        print "#{@year} day #{day}... "
        results = Advent::Benchmark.precise_benchmark do
          Challenge.run(year: @year, day: day)
        end
        print "#{(results.average * 1000).round(2)}ms\n"
      end
    end

    # Profiles the specified day using StackProf.
    # Generates a profile dump file in tmp/ directory.
    #
    # @return [void]
    # @note Requires a specific day (will not profile all days)
    # @example
    #   benchmark.stackprof
    #   # Creates tmp/stackprof-wall-2024-1.dump
    #   # View with: stackprof tmp/stackprof-wall-2024-1.dump
    def stackprof
      filename = "tmp/stackprof-wall-#{@year}-#{@day}.dump"
      StackProf.run(mode: :wall, raw: true, out: filename) do
        Challenge.run(year: @year, day: @day)
      end
    end

    # Returns the list of days to benchmark.
    #
    # @return [Array<Integer>] Array of day numbers to benchmark
    # @api private
    def days
      if @day.nil?
        Dir.glob("lib/advent/year#{@year}/day*.rb").map do |file|
          file[/day(\d+)/, 1].to_i
        end
      else
        [@day.to_i]
      end
    end

    class << self
      # Performs precise benchmark timing with garbage collection disabled.
      # Runs the block multiple times and calculates statistical measures.
      #
      # @param iterations [Integer] Number of times to run the benchmark (default: 5)
      # @yieldreturn [void] The block to benchmark
      # @return [Result] Benchmark results with average, times, and standard deviation
      # @example
      #   result = Benchmark.precise_benchmark(10) do
      #     expensive_operation
      #   end
      #   puts "Average: #{result.average}s"
      #   puts "StdDev: #{result.standard_deviation}s"
      def precise_benchmark(iterations = 5)
        times = iterations.times.map do
          GC.disable # Disable garbage collection for more consistent measurements
          start = Process.clock_gettime(Process::CLOCK_MONOTONIC)
          yield
          finish = Process.clock_gettime(Process::CLOCK_MONOTONIC)
          GC.enable
          finish - start
        end

        # Calculate statistics
        average = times.sum / iterations
        variance = times.map { |t| (t - average)**2 }.sum / iterations
        standard_deviation = Math.sqrt(variance)

        Result.new(average:, times:, standard_deviation:)
      end
    end
  end
end
