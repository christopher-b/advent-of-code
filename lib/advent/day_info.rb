module Advent
  DayInfo = Data.define(:year, :day) do
    def challenge_class
      Object.const_get "Advent::Year#{year}::Day#{padded_day}"
    end

    def input
      File.open(input_path, "r")
    end

    def sample_input
      File.open(sample_input_path, "r")
    end

    def input_path
      "#{input_directory}/#{padded_day}-input.txt"
    end

    def sample_input_path
      "#{input_directory}/#{padded_day}-sample.txt"
    end

    def code_directory
      "lib/advent/year#{year}"
    end

    def input_directory
      "data/#{year}"
    end

    def test_directory
      "test/advent/year#{year}"
    end

    def challenge_path
      "#{code_directory}/day#{padded_day}.rb"
    end

    def test_path
      "#{test_directory}/day#{padded_day}.test.rb"
    end

    def padded_day
      Advent.pad_day(day)
    end
  end
end
