# https://adventofcode.com/2025/day/3
challenge = Advent::Challenge.get_with_sample(year: 2025, day: 3)
BatteryBank = Advent::Year2025::Day03::BatteryBank

test "part 1" do
  # assert_equal 357, challenge.part1
end

test "part 2" do
  # assert_equal 3121910778619, challenge.part2
end

test "joltages" do
  # assert_equal 98, BatteryBank.new(987654321111111).joltage
  # assert_equal 89, BatteryBank.new(811111111111119).joltage
  # assert_equal 78, BatteryBank.new(234234234234278).joltage
  # assert_equal 92, BatteryBank.new(818181911112111).joltage
end

test "complex joltages" do
  assert_equal 987654321111, BatteryBank.new(987654321111111).complex_joltage
  assert_equal 811111111119, BatteryBank.new(811111111111119).complex_joltage
  assert_equal 434234234278, BatteryBank.new(234234234234278).complex_joltage
  assert_equal 888911112111, BatteryBank.new(818181911112111).complex_joltage
end
