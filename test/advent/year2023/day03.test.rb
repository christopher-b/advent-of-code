# https://adventofcode.com/2023/day/3
challenge = Advent::Challenge.get_with_sample(year: 2023, day: 3)

test "part 1" do
  assert challenge.part1 == 4361
end

test "part 2" do
  assert challenge.part2 == 467835
end
