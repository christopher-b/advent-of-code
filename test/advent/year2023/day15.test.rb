# https://adventofcode.com/2023/day/15
challenge = Advent::Challenge.get_with_sample(year: 2023, day: 15)

test "part 1" do
  assert challenge.part1 == 1320
end

test "part 2" do
  assert challenge.part2 == 145
end
