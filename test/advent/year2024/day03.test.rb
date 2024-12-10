# https://adventofcode.com/2024/day/3
challenge = Advent::Challenge.get_with_sample(year: 2024, day: 3)

def setup_part_2(challenge)
  challenge.input_file = StringIO.new("xmul(2,4)&mul[3,7]!^don't()_mul(5,5)+mul(32,64](mul(11,8)undo()?mul(8,5))")
end

test "part 1" do
  assert challenge.part1 == 161
end

test "part 2" do
  setup_part_2(challenge)
  assert challenge.part2 == 48
end

test "matches" do
  assert challenge.mul_matches.first == "mul(2,4)"
end

test "map_digits" do
  assert challenge.mul_digits("mul(2,4)") == [2, 4]
end

test "more_matches" do
  setup_part_2(challenge)
  assert challenge.more_matches == [
    "mul(2,4)",
    "don't()",
    "mul(5,5)",
    "mul(11,8)",
    "do()",
    "mul(8,5)"
  ]
end
