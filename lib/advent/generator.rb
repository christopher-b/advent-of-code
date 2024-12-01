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

      logger.info "Generating challenge at #{day_info.challenge_file}"
      logger.info "Challenge already exists" unless generate_challenge

      logger.info "Generating test at #{day_info.test_file}"
      logger.info "Test already exists" unless generate_test

      logger.info "Generating data files at #{day_info.data_path} and #{day_info.sample_data_path}"
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
      if File.exist?(dest)
        false
      else
        File.write(dest, challenge_contents)
        true
      end
    end

    def generate_test
      dest = day_info.test_file
      test_contents = Templates::TEST % {year: day_info.year, day: day_info.day}
      if File.exist?(dest)
        false
      else
        File.write(dest, test_contents)
        true
      end
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
      day_info = DayInfo.new(%{year}, %{day})
      challenge = day_info.challenge_with_sample

      test "part 1" do
        assert challenge.part1 == 0
      end

      test "part 2" do
        assert challenge.part2 == 0
      end
    TEST
  end
end
