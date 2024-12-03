# https://adventofcode.com/2023/day/7
challenge = Advent::Challenge.get_with_sample(year: 2023, day: 7)

test "part 1" do
  assert challenge.part1 == 6440
end

test "part 2" do
  assert challenge.part2 == 5905
end
