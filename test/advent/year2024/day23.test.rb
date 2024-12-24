# https://adventofcode.com/2024/day/23
challenge = Advent::Challenge.get_with_sample(year: 2024, day: 23)

test "part 1" do
  assert_equal 7, challenge.part1
end

test "part 2" do
  assert_equal "co,de,ka,ta", challenge.part2
end

test "graph" do
  # assert_equal 31, challenge.graph.adjacency_list.size
end
