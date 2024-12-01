DayInfo = Data.define(:year, :day) do
  def challenge_class
    Object.const_get "Advent::Year#{year}::Day#{padded_day}"
  end

  def run_challenge
    challenge_with_data.call
  end

  def run_challenge_with_sample
    challenge_with_sample.call
  end

  def challenge_with_data
    challenge_class.new(data)
  end

  def challenge_with_sample
    challenge_class.new(sample_data)
  end

  def padded_day
    Advent.pad_day(day)
  end

  def data_path
    "#{data_directory}/#{padded_day}-data.txt"
  end

  def data
    File.open(data_path, "r")
  end

  def sample_data_path
    "#{data_directory}/#{padded_day}-sample.txt"
  end

  def sample_data
    File.open(sample_data_path, "r")
  end

  def code_directory
    "lib/advent/year#{year}"
  end

  def data_directory
    "data/#{year}"
  end

  def test_directory
    "test/advent/year#{year}"
  end

  def challenge_file
    "#{code_directory}/day#{padded_day}.rb"
  end

  def test_file
    "#{test_directory}/day#{padded_day}.test.rb"
  end
end
