require "fileutils"
require "open-uri"

module Advent
  class Generator
    attr_reader :day_info, :logger

    def initialize(year:, day:, logger: Logger.new(nil))
      @day_info = DayInfo.new(year:, day:)
      @logger = logger
    end

    def call
      logger.info "Initializing challenge for #{day_info.year} Day #{day_info.day}"

      prepare_directory_structure
      generate_challenge unless challenge_exists?
      generate_test unless test_exists?
      generate_input unless input_exists?
    end

    def prepare_directory_structure
      logger.info "Ensuring year folders exist"
      [
        day_info.code_directory,
        day_info.input_directory,
        day_info.test_directory
      ].each { |dir| FileUtils.mkdir_p(dir) }
    end

    # Create the challenge file if it doesn't exist
    def generate_challenge
      challenge_path = day_info.challenge_path
      logger.info "Generating challenge at #{challenge_path}"

      File.write(challenge_path, challenge_template)
      true
    end

    # Create the test file if it doesn't exist
    def generate_test
      test_path = day_info.test_path
      logger.info "Generating test at #{test_path}"

      File.write(test_path, test_template)
      true
    end

    # Download the input file if it doesn't exist
    def generate_input
      logger.info "Generating input files at #{day_info.input_path} and #{day_info.sample_input_path}"

      FileUtils.touch(day_info.sample_input_path)
      input_downloader.download
      true
    end

    def challenge_exists?
      File.exist?(day_info.challenge_path)
    end

    def test_exists?
      File.exist?(day_info.test_path)
    end

    def input_exists?
      File.exist?(day_info.input_path)
    end

    def input_downloader
      @input_downloader ||= InputDownloader.new(day_info, logger)
    end

    def challenge_template
      Templates::CHALLENGE % {year: day_info.year, day: day_info.padded_day}
    end

    def test_template
      Templates::TEST % {year: day_info.year, day: day_info.day}
    end
  end

  class InputDownloader
    attr_reader :day_info, :logger

    def initialize(day_info, logger)
      @day_info = day_info
      @logger = logger
    end

    def download
      validate_session_cookie

      logger.info "Downloading input from #{url}"
      URI.parse(url).open(headers) do |remote_file|
        IO.copy_stream(remote_file, destination)
      end
    rescue OpenURI::HTTPError => e
      logger.error "Failed to download input: #{e.message}"
      raise
    end

    def validate_session_cookie
      return if session_cookie

      logger.error "No session cookie found"
      raise MissingSessionCookieError, "Please set AOC_SESSION in env"
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
      # https://adventofcode.com/%{year}/day/%{day}
      module Advent
        module Year%{year}
          class Day%{day} < Advent::Challenge
            # Explanation here

            def part1
            end

            def part2
            end
          end
        end
      end
    CHALLENGE

    TEST = <<~TEST
      # https://adventofcode.com/%{year}/day/%{day}
      challenge = Advent::Challenge.get_with_sample(year: %{year}, day: %{day})

      test "part 1" do
        # pp challenge.part1
        # assert challenge.part1 == 0
      end

      test "part 2" do
        # pp challenge.part2
        # assert challenge.part2 == 0
      end
    TEST
  end
end
