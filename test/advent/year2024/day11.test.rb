# https://adventofcode.com/2024/day/11
challenge = Advent::Challenge.get_with_sample(year: 2024, day: 11)
StoneSet = Advent::Year2024::Day11::StoneSet

test "part 1 & 2" do
  # Must run in order
  expect(challenge.part1) == 55312
  expect(challenge.part2) == 65601038650482
end

test "StoneSet#initialize" do
  stones = StoneSet.new([1, 1, 2])
  assert stones.stones == {1 => 2, 2 => 1}
end

test "RuleSet#blink" do
  r = StoneSet.new([125, 17])
  r.blink
  assert r.stones == {1 => 1, 7 => 1, 17 => 0, 125 => 0, 253000 => 1}
end

test "RuleSet#size" do
  r = StoneSet.new([1, 1, 2])
  assert r.size == 3
end
