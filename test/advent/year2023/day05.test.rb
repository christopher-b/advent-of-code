# https://adventofcode.com/2023/day/5
challenge = Advent::Challenge.get_with_sample(year: 2023, day: 5)
challenge.parse_input

test "part 1" do
  assert challenge.part1 == 35
end

test "part 2" do
  assert challenge.part2 == 46
end

test "seeds" do
  assert challenge.seeds == [79, 14, 55, 13]
end

test "creates maps" do
  map = challenge.maps.first
  assert map.src_name == "seed"
  assert map.dest_name == "soil"
  assert map.ranges == [
    Advent::Year2023::Day05::Range.new(50, 98, 2),
    Advent::Year2023::Day05::Range.new(52, 50, 48)
  ]
end

test "map dest" do
  seed_to_soil = challenge.maps.first
  assert seed_to_soil.src_name == "seed"
  assert seed_to_soil.dest_name == "soil"

  dest = seed_to_soil.dest
  assert dest.src_name == "soil"
end

test "map output" do
  seed_to_soil = challenge.maps.first
  output = seed_to_soil.output(98)
  assert output == 50
end

test "map output with no range" do
  seed_to_soil = challenge.maps.first
  output = seed_to_soil.output(1)
  assert output == 1
end

test "maps inputs through many maps" do
  seed = 79
  seed_to_soil = challenge.maps.first
  assert seed_to_soil.map(seed) == 82
end

test "parse" do
  challenge.parse_input
end
