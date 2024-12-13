# https://adventofcode.com/2023/day/10
challenge = Advent::Challenge.get_with_sample(year: 2023, day: 10)
challenge.parse_input

test "part 1" do
  assert challenge.part1 == 8
end

test "part 2" do
  # assert challenge.part2 == 0
end
