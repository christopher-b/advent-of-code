day_info = Advent::DayInfo.new(2099, 1)

test "creates a new day_info" do
  assert day_info.year == 2099
  assert day_info.day == 1
end

test "returns the challenge class" do
  assert day_info.challenge_class == Advent::Year2099::Day01
end

test "returns the sample input" do
  assert File === day_info.sample_input
end

test "returns the input" do
  assert File === day_info.input
end
