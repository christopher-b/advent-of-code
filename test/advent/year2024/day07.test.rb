# https://adventofcode.com/2024/day/7
challenge = Advent::Challenge.get_with_sample(year: 2024, day: 7)
Calibration = Advent::Year2024::Day07::Calibration

test "part 1" do
  assert challenge.part1 == 3749
end

test "part 2" do
  expect(challenge.part2) == 11387
end

test "parses calibrations" do
  assert challenge.calibrations.size == 9
  expect(challenge.calibrations.first) == Calibration.new(190, [10, 19])
end

test "Calibrations#valid" do
  calibration = Calibration.new(190, [10, 19])
  assert calibration.valid?

  calibration = Calibration.new(3267, [81, 40, 27])
  assert calibration.valid?

  calibration = Calibration.new(83, [17, 50])
  refute calibration.valid?
end
