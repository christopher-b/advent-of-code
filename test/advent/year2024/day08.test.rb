# https://adventofcode.com/2024/day/8
challenge = Advent::Challenge.get_with_sample(year: 2024, day: 8)
Point = Advent::Point

test "part 1" do
  expect(challenge.part1) == 14
end

test "part 2" do
  expect(challenge.part2) == 34
end

test "nodes" do
  map = challenge.map
  assert map.node_sets.keys == ["0", "A"]
end
