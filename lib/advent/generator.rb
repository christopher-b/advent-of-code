require "fileutils"
require "open-uri"

module Advent
  class Generator
    attr_reader :day_info
    attr_reader :logger

    def initialize(year:, day:, logger: Logger.new(nil))
      @day_info = DayInfo.new(year:, day:)
      @logger = logger
    end

    def call
      logger.info "Initializing challenge for #{day_info.year} Day #{day_info.day}"

      logger.info "Ensuring year folders exist"
      ensure_year_folders

      logger.info "Generating challenge at #{day_info.challenge_path}"
      generate_challenge || logger.info { "└─Challenge already exists" }

      logger.info "Generating test at #{day_info.test_path}"
      generate_test || logger.info { "└─Test already exists" }

      logger.info "Generating input files at #{day_info.input_path} and #{day_info.sample_input_path}"
      generate_input || logger.info { "└─Input file already exist" }
    end

    # Ensure the year folders exist
    def ensure_year_folders
      FileUtils.mkdir_p day_info.code_directory
      FileUtils.mkdir_p day_info.input_directory
      FileUtils.mkdir_p day_info.test_directory
    end

    # Create the day file if it doesn't exist
    def generate_challenge
      dest = day_info.challenge_path
      return false if File.exist?(dest)

      challenge_contents = Templates::CHALLENGE % {year: day_info.year, day: day_info.padded_day}
      File.write(dest, challenge_contents)
      true
    end

    # Create the test file if it doesn't exist
    def generate_test
      dest = day_info.test_path
      return false if File.exist?(dest)

      test_contents = Templates::TEST % {year: day_info.year, day: day_info.day}
      File.write(dest, test_contents)
      true
    end

    # Download the input file if it doesn't exist
    def generate_input
      return false if File.exist?(day_info.input_path)

      FileUtils.touch(day_info.sample_input_path)
      downloader.call
      true
    end

    def downloader
      @downloader ||= InputDownloader.new(day_info)
    end
  end

  class InputDownloader
    attr_reader :day_info

    def initialize(day_info)
      @day_info = day_info
    end

    def call
      raise "No session cookie found. Please set AOC_SESSION in env" unless session_cookie

      URI.parse(url).open(headers) do |remote_file|
        IO.copy_stream(remote_file, destination)
      end
    end

    def url
      @url ||= "https://adventofcode.com/%{year}/day/%{day}/input" % {
        year: day_info.year,
        day: day_info.day
      }
    end

    def headers
      {"Cookie" => "session=#{session_cookie}"}
    end

    def destination
      day_info.input_path
    end

    def session_cookie
      ENV["AOC_SESSION"]
    end
  end

  module Templates
    CHALLENGE = <<~CHALLENGE
      module Advent
        module Year%{year}
          class Day%{day} < Advent::Challenge
            def call
              puts "Part 1: \#{part1}"
              puts "Part 2: \#{part2}"
            end

            def part1
              0
            end

            def part2
              0
            end
          end
        end
      end
    CHALLENGE

    TEST = <<~TEST
      challenge = Advent::Challenge.get_with_sample(year: %{year}, day: %{day})

      test "part 1" do
        assert challenge.part1 == 0
      end

      test "part 2" do
        assert challenge.part2 == 0
      end
    TEST
  end
end
