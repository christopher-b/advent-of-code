# https://adventofcode.com/2024/day/10
challenge = Advent::Challenge.get_with_sample(year: 2024, day: 10)

test "part 1" do
  assert challenge.part1 == 36
end

test "part 2" do
  expect(challenge.part2) == 81
end
