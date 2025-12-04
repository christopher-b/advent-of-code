# https://adventofcode.com/2025/day/4
challenge = Advent::Challenge.get_with_sample(year: 2025, day: 4)

test "part 1" do
  assert_equal 13, challenge.part1
end

test "part 2" do
  assert_equal 43, challenge.part2
end
