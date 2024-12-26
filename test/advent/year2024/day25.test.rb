# https://adventofcode.com/2024/day/25
challenge = Advent::Challenge.get_with_sample(year: 2024, day: 25)
challenge.parse_input

test "part 1" do
  assert_equal 3, challenge.part1
end

test "part 2" do
  # assert_equal 0, challenge.part2
end

test "parse" do
  assert_equal 3, challenge.keys.size
  assert_equal 2, challenge.locks.size
end

test "heights" do
  lock = challenge.locks.first
  assert_equal [0, 5, 3, 4, 3], lock.heights
end
