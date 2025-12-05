# https://adventofcode.com/2025/day/5
challenge = Advent::Challenge.get_with_sample(year: 2025, day: 5)

test "part 1" do
  assert_equal 3, challenge.part1
end

test "part 2" do
  assert_equal 14, challenge.part2
end
