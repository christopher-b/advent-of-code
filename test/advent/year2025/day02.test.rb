# https://adventofcode.com/2025/day/2
challenge = Advent::Challenge.get_with_sample(year: 2025, day: 2)

test "part 1" do
  assert_equal 1227775554, challenge.part1
end

test "part 2" do
  assert_equal 4174379265, challenge.part2
end
