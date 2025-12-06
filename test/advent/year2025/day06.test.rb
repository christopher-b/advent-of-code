# https://adventofcode.com/2025/day/6
challenge = Advent::Challenge.get_with_sample(year: 2025, day: 6)

test "part 1" do
  assert_equal 4277556, challenge.part1
end

test "part 2" do
  assert_equal 3263827, challenge.part2
end
