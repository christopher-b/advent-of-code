# https://adventofcode.com/2024/day/4
challenge = Advent::Challenge.get_with_sample(year: 2024, day: 4)

test "part 1" do
  assert challenge.part1 == 18
end

test "part 2" do
  assert challenge.part2 == 9
end

test "vectors" do
  assert challenge.vector_set_omni.size == 8
end

test "Vector#increment" do
  vector = Advent::Year2024::Day04::Vector.new(x: 1, y: 1, grid: ["ABC"])
  vector.current = Advent::Year2024::Day04::Point.new(x: 0, y: 0)

  vector.increment
  assert vector.current == Advent::Year2024::Day04::Point.new(x: 1, y: 1)
end

test "Vector#next_value" do
  grid = [
    "ABC",
    "DEF"
  ]
  vector = Advent::Year2024::Day04::Vector.new(x: 1, y: 1, grid: grid)
  vector.current = Advent::Year2024::Day04::Point.new(x: 0, y: 0)

  assert vector.next_value == "E"
end

# test "adjacent_nodes" do
#   assert challenge.adjacent_nodes(0, 0) == [[1, 0], [0, 1], [1, 1]].sort
#   assert challenge.adjacent_nodes(1, 1) == [[0, 0], [1, 0], [0, 1], [2, 0], [2, 1], [0, 2], [1, 2], [2, 2]].sort
# end
