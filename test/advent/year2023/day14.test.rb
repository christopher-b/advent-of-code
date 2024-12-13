# https://adventofcode.com/2023/day/14
challenge = Advent::Challenge.get_with_sample(year: 2023, day: 14)

test "part 1" do
  expect(challenge.part1) == 112046
end

test "part 2" do
  expect(challenge.part2) == 64
end
