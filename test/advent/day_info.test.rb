test "creates a new day_info" do
  day_info = DayInfo.new(year: 2024, day: 1)
  assert day_info.year == 2024
  assert day_info.day == 1
end

test "returns the challenge class" do
  day_info = DayInfo.new(year: 2024, day: 1)
  assert day_info.challenge_class == Advent::Year2024::Day01
end

test "returns the sample data" do
  day_info = DayInfo.new(year: 2024, day: 1)
  assert File === day_info.sample_data
end

test "returns the data" do
  day_info = DayInfo.new(year: 2024, day: 1)
  assert File === day_info.data
end
