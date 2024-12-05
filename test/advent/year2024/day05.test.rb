# https://adventofcode.com/2024/day/5
challenge = Advent::Challenge.get_with_sample(year: 2024, day: 5)
challenge.parse_input

test "part 1" do
  assert challenge.part1 == 143
end

test "part 2" do
  assert challenge.part2 == 123
end

test "invalid updates" do
  assert challenge.invalid_updates.size == 3
end

test "tsort" do
  assert challenge.invalid_updates.first.sort!.pages == [97, 75, 47, 61, 53]
end
