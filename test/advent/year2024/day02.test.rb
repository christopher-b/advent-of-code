challenge = Advent::Challenge.get_with_sample(year: 2024, day: 2)

test "part 1" do
  expect(challenge.part1) == 2
end

test "part 2" do
  expect(challenge.part2) == 4
end

test "reports" do
  assert challenge.reports.size == 6
end

test "unsafe if increasing and decreasing" do
  report = Advent::Year2024::Day02::Report.new("1 2 1")
  refute report.safe?
end

test "safe if only increasing" do
  report = Advent::Year2024::Day02::Report.new("1 2 3")
  assert report.safe?
end

test "safe if only decreasing" do
  report = Advent::Year2024::Day02::Report.new("3 2 1")
  assert report.safe?
end

test "unsafe if difference is greater than 3" do
  report = Advent::Year2024::Day02::Report.new("1 5 6")
  refute report.safe?
end

test "safe if difference is less than or equal to 3" do
  report = Advent::Year2024::Day02::Report.new("1 4 5")
  assert report.safe?
end

test "unsafe if difference is zero" do
  report = Advent::Year2024::Day02::Report.new("1 1 1")
  refute report.safe?
end

test "safe if dampener and one error" do
  report = Advent::Year2024::Day02::Report.new("1 2 9 3")
  assert report.safe_with_dampener?
end

test "unsafe if dampener and two errors" do
  report = Advent::Year2024::Day02::Report.new("1 2 9 3 9 4")
  refute report.safe_with_dampener?
end
