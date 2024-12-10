require 'stackprof'

module Advent
  class Benchmark
    Result = Data.define(:average, :times, :standard_deviation)

    def initialize(year, day = nil)
      @year = year
      @day = day
    end

    def run
      puts "Running benchmarks..."
      days.each do |day|
        print "#{@year} day #{@day}... "
        results = Advent::Benchmark.precise_benchmark do
          Challenge.run(year: @year, day: @day)
        end
        print "#{(results.average * 1000).round(2)}ms\n"
      end
    end

    def stackprof
      filename = "tmp/stackprof-wall-#{@year}-#{@day}.dump"
      StackProf.run(mode: :wall, raw: true, out: filename) do
        Challenge.run(year: @year, day: @day)
      end
    end

    def days
      if @day.nil?
        Dir.glob("lib/advent/year#{year}/day*.rb").map do |file|
          file[/day(\d+)/, 1].to_i
        end
      else
        [@day.to_i]
      end
    end

    class << self
      def precise_benchmark(iterations = 5)
        times = iterations.times.map do
          GC.disable  # Disable garbage collection for more consistent measurements
          start = Process.clock_gettime(Process::CLOCK_MONOTONIC)
          yield
          finish = Process.clock_gettime(Process::CLOCK_MONOTONIC)
          GC.enable
          finish - start
        end

        # Calculate statistics
        average = times.sum / iterations
        variance = times.map { |t| (t - average) ** 2 }.sum / iterations
        standard_deviation = Math.sqrt(variance)

        Result.new(average:, times:, standard_deviation:)
      end
    end
  end
end
