# https://adventofcode.com/2023/day/4
challenge = Advent::Challenge.get_with_sample(year: 2023, day: 4)

test "part 1" do
  assert challenge.part1 == 13
end

test "part 2" do
  assert challenge.part2 == 30
end
