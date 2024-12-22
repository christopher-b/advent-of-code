# https://adventofcode.com/2024/day/21
challenge = Advent::Challenge.get_with_sample(year: 2024, day: 21)
Numpad = challenge.class.const_get(:Numpad)
Keypad = challenge.class.const_get(:Keypad)

test "part 1" do
  assert_equal 126384, challenge.part1
end

test "part 2" do
end

test "numpad presses" do
  # num = Numpad.new
  # pp num.presses_for(0)
  # pp num.presses_for(0)

  # path = num.presses_for("A", 7)
  # expected = ["^", "^", "<", "<", "^"]
  # assert_equal expected, path
end

# test "graph check" do
#   pp challenge.numpad.bfs_paths("A", 7)
# end
