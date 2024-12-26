# https://adventofcode.com/2024/day/24
challenge = Advent::Challenge.get_with_sample(year: 2024, day: 24)

test "part 1" do
  assert_equal 2024, challenge.part1
end

test "part 2" do
  challenge.part2
  # assert_equal 0, challenge.part2
end
