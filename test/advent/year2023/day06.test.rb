# https://adventofcode.com/2023/day/6
challenge = Advent::Challenge.get_with_sample(year: 2023, day: 6)

test "part 1" do
  assert challenge.part1 == 288
end

test "part 2" do
  assert challenge.part2 == 71503
end