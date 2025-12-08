require "fileutils"
require "open-uri"

module Advent
  # Generates scaffold files for a new Advent of Code challenge day.
  # Creates challenge implementation, test file, and downloads input data.
  #
  # @example Generating files for a new day
  #   logger = Logger.new($stdout)
  #   generator = Generator.new(year: 2024, day: 1, logger: logger)
  #   generator.call
  class Generator
    # @return [DayInfo] Information about the challenge day being generated
    attr_reader :day_info
    # @return [Logger] Logger for output messages
    attr_reader :logger

    # Creates a new Generator for the specified year and day.
    #
    # @param year [Integer, String] The year of the challenge
    # @param day [Integer, String] The day of the challenge (1-25)
    # @param logger [Logger] Logger for output (defaults to silent logger)
    def initialize(year:, day:, logger: Logger.new(nil))
      @day_info = DayInfo.new(year:, day:)
      @logger = logger
    end

    # Generates all necessary files for a new challenge day.
    # Creates directories, challenge file, test file, and downloads input.
    # Skips files that already exist.
    #
    # @return [void]
    def call
      logger.info "Initializing challenge for #{day_info.year} Day #{day_info.day}"

      prepare_directory_structure
      generate_challenge unless challenge_exists?
      generate_test unless test_exists?
      generate_input unless input_exists?
    end

    # Creates the directory structure for the challenge.
    # Ensures code, input, and test directories exist.
    #
    # @return [void]
    def prepare_directory_structure
      logger.info "Ensuring year folders exist"
      [
        day_info.code_directory,
        day_info.input_directory,
        day_info.test_directory
      ].each { |dir| FileUtils.mkdir_p(dir) }
    end

    # Creates the challenge file from a template.
    #
    # @return [Boolean] Always returns true
    def generate_challenge
      challenge_path = day_info.challenge_path
      logger.info "Generating challenge at\n\t#{challenge_path}"

      File.write(challenge_path, challenge_template)
      true
    end

    # Creates the test file from a template.
    #
    # @return [Boolean] Always returns true
    def generate_test
      test_path = day_info.test_path
      logger.info "Generating test at\n\t#{test_path}"

      File.write(test_path, test_template)
      true
    end

    # Creates empty sample input file and downloads actual input.
    #
    # @return [Boolean] Always returns true
    def generate_input
      logger.info "Generating input files at\n\t#{day_info.input_path}\n\t#{day_info.sample_input_path}"

      FileUtils.touch(day_info.sample_input_path)
      input_downloader.download
      true
    end

    # Checks if the challenge file already exists.
    #
    # @return [Boolean] True if challenge file exists
    def challenge_exists?
      File.exist?(day_info.challenge_path)
    end

    # Checks if the test file already exists.
    #
    # @return [Boolean] True if test file exists
    def test_exists?
      File.exist?(day_info.test_path)
    end

    # Checks if the input file already exists.
    #
    # @return [Boolean] True if input file exists
    def input_exists?
      File.exist?(day_info.input_path)
    end

    # Returns an InputDownloader instance for downloading puzzle input.
    #
    # @return [InputDownloader] Downloader instance
    def input_downloader
      @input_downloader ||= InputDownloader.new(day_info, logger)
    end

    # Generates the challenge file content from template.
    #
    # @return [String] Challenge file content
    def challenge_template
      format(Templates::CHALLENGE, year: day_info.year, day: day_info.padded_day)
    end

    # Generates the test file content from template.
    #
    # @return [String] Test file content
    def test_template
      format(Templates::TEST, year: day_info.year, day: day_info.day)
    end
  end

  # Downloads puzzle input from the Advent of Code website.
  # Requires AOC_SESSION environment variable to be set with a valid session cookie.
  #
  # @example Downloading input
  #   day_info = DayInfo.new(year: 2024, day: 1)
  #   downloader = InputDownloader.new(day_info, Logger.new($stdout))
  #   downloader.download
  class InputDownloader
    # @return [DayInfo] Information about the challenge day
    attr_reader :day_info
    # @return [Logger] Logger for output messages
    attr_reader :logger

    # Creates a new InputDownloader.
    #
    # @param day_info [DayInfo] Information about the challenge day
    # @param logger [Logger] Logger for output messages
    def initialize(day_info, logger)
      @day_info = day_info
      @logger = logger
    end

    # Downloads the input file from adventofcode.com.
    #
    # @return [void]
    # @raise [MissingSessionCookieError] If AOC_SESSION environment variable is not set
    # @raise [OpenURI::HTTPError] If download fails
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

    # Validates that the session cookie is present.
    # Prompts user to enter the cookie if not found in environment.
    #
    # @return [void]
    def validate_session_cookie
      return if session_cookie

      logger.warn "No AOC_SESSION found in environment"
      print "Please enter your Advent of Code session cookie: "
      user_input = $stdin.gets&.chomp

      if user_input && !user_input.empty?
        set_session_cookie(user_input)
        logger.info "Session cookie set successfully"
      else
        logger.error "No session cookie provided"
        raise MissingSessionCookieError, "Session cookie is required to download input"
      end
    end

    # Constructs the URL for downloading input.
    #
    # @return [String] The download URL
    def url
      @url ||= format("https://adventofcode.com/%<year>s/day/%<day>s/input", year: day_info.year, day: day_info.day)
    end

    # Constructs HTTP headers with session cookie.
    #
    # @return [Hash<String, String>] Headers hash with cookie
    def headers
      {"Cookie" => "session=#{session_cookie}"}
    end

    # Returns the destination path for the downloaded file.
    #
    # @return [String] Path to save the input file
    def destination
      day_info.input_path
    end

    # Retrieves the session cookie from environment.
    #
    # @return [String, nil] The session cookie or nil if not set
    def session_cookie
      ENV["AOC_SESSION"]
    end

    def set_session_cookie(cookie)
      ENV["AOC_SESSION"] = cookie
    end
  end

  # Module containing file templates for generated files.
  module Templates
    # Template for challenge implementation file.
    # Contains a class that inherits from Advent::Challenge with part1 and part2 methods.
    #
    # @api private
    CHALLENGE = <<~CHALLENGE
      # https://adventofcode.com/%<year>s/day/%<day>s
      module Advent
        module Year%<year>s
          class Day%<day>s < Advent::Challenge
            # Explanation here

            def part1
            end

            def part2
            end
          end
        end
      end
    CHALLENGE

    # Template for test file.
    # Contains skeleton tests for part1 and part2 using sample input.
    #
    # @api private
    TEST = <<~TEST
      # https://adventofcode.com/%<year>s/day/%<day>s
      challenge = Advent::Challenge.get_with_sample(year: %<year>s, day: %<day>s)

      test "part 1" do
        # assert_equal 0, challenge.part1
      end

      test "part 2" do
        # assert_equal 0, challenge.part2
      end
    TEST
  end
end
