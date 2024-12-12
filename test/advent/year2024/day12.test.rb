# https://adventofcode.com/2024/day/12
challenge = Advent::Challenge.get_with_sample(year: 2024, day: 12)

test "part 1" do
  expect(challenge.part1) == 1930
end

test "part 2" do
  expect(challenge.part2) == 1206
end

test "Point set equality" do
  point1 = Advent::Point.new(1, 2)
  point2 = Advent::Point.new(1, 2)
  point3 = Advent::Point.new(1, 3)

  assert point1 == point2
  assert point1 != point3

  set = Set.new([point1])
  assert set.include?(point2)
  assert !set.include?(point3)

  assert Set.new([[point1, point2]]).include?([point2, point1])
end

