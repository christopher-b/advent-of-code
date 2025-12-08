# https://adventofcode.com/2025/day/7
challenge = Advent::Challenge.get_with_sample(year: 2025, day: 7)
challenge.parse_input

test "part 1" do
  assert_equal 21, challenge.part1
end

test "part 2" do
  assert_equal 40, challenge.part2
end

test "origin" do
  assert_equal 7, challenge.origin_x
end
