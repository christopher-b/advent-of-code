require "fileutils"

module Advent
  class Generator
    attr_reader :day_info

    def initialize(day:, year:)
      @day_info = DayInfo.new(day:, year:)
    end

    def call(logger)
      logger.info "Initializing challenge for #{day_info.year} Day #{day_info.day}"

      logger.info "Ensuring year folders exist"
      ensure_year_folders

      logger.info "Generating challenge"
      generate_challenge

      logger.info "Generating test"
      generate_test

      logger.info "Generating data"
      generate_data
    end

    # Ensure the year folders exist
    def ensure_year_folders
      FileUtils.mkdir_p day_info.code_directory
      FileUtils.mkdir_p day_info.data_directory
      FileUtils.mkdir_p day_info.test_directory
    end

    # Create the day file if it doesn't exist
    def generate_challenge
      dest = day_info.challenge_file
      challenge_contents = Templates::CHALLENGE % {year: day_info.year, day: day_info.padded_day}
      File.write(dest, challenge_contents) unless File.exist?(dest)
    end

    def generate_test
      dest = day_info.test_file
      test_contents = Templates::TEST % {year: day_info.year, day: day_info.day}
      File.write(dest, test_contents) unless File.exist?(dest)
    end

    def generate_data
      FileUtils.touch(day_info.data_path)
      FileUtils.touch(day_info.sample_data_path)
    end
  end

  module Templates
    CHALLENGE = <<~CHALLENGE
      module Advent
        module Year%{year}
          class Day%{day} < Advent::Challenge
            def call
              true
            end
          end
        end
      end
    CHALLENGE

    TEST = <<~TEST
      day_info = DayInfo.new(%{year}, %{day})
      challenge = day_info.challenge_with_sample

      test "" do
        result = challenge.call
        assert result
      end
    TEST
  end
end
