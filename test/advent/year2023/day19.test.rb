# https://adventofcode.com/2023/day/19
challenge = Advent::Challenge.get_with_sample(year: 2023, day: 19)
challenge.parse_input

test "part 1" do
  expect(challenge.part1) == 19114
end

test "part 2" do
  # expect(challenge.part2) == 167409079868000
end
