# https://adventofcode.com/2024/day/5
challenge = Advent::Challenge.get_with_sample(year: 2024, day: 5)
challenge.parse_input

test "part 1" do
  assert challenge.part1 == 143
end

test "part 2" do
  assert challenge.part2 == 123
end

test "rules" do
  assert challenge.rules[47].first == [47, 53]
  assert challenge.rules[47].size == 6
end

test "updates" do
  assert challenge.updates.first == [75, 47, 61, 53, 29]
  assert challenge.updates.size == 6
end

test "updates to print" do
  assert challenge.correct_updates.size == 3
end

test "incorrect updates" do
  assert challenge.incorrect_updates.size == 3
end
