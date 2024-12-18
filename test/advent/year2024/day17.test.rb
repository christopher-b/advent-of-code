# https://adventofcode.com/2024/day/17
challenge = Advent::Challenge.get_with_sample(year: 2024, day: 17)
Computer = challenge.class.const_get(:Computer)

test "part 1" do
  assert_equal "4,6,3,5,6,3,5,2,1,0", challenge.part1
end

test "part 2" do
  # assert_equal 117440, challenge.part2
end

test "samples" do
  computer = Computer.new({c: 9}, [2, 6])
  assert_equal 1, computer.run.registers[:b]

  computer = Computer.new({a: 10}, [5, 0, 5, 1, 5, 4])
  assert_equal "0,1,2", computer.run.output

  computer = Computer.new({a: 2024}, [0, 1, 5, 4, 3, 0])
  computer.run
  assert_equal "4,2,5,6,7,7,7,7,3,1,0", computer.output
  assert_equal 0, computer.run.registers[:a]

  computer = Computer.new({b: 29}, [1, 7])
  assert_equal 26, computer.run.registers[:b]

  computer = Computer.new({b: 2024, c: 43690}, [4, 0])
  assert_equal 44354, computer.run.registers[:b]
end

# test "registers" do
#   assert_equal 729, challenge.registers[:a]
# end
#
# test "instructions" do
#   assert_equal 6, challenge.instructions.size
# end
#
test "Computer#registers" do
  computer = Computer.new({a: 4, b: 5, c: 6}, [])
  assert_equal 4, computer.registers[:a]
  assert_equal 5, computer.registers[:b]
  assert_equal 6, computer.registers[:c]
end

test "Computer#combo" do
  computer = Computer.new({a: 40, b: 50, c: 60}, [])
  assert_equal 0, computer.combo(0)
  assert_equal 1, computer.combo(1)
  assert_equal 2, computer.combo(2)
  assert_equal 3, computer.combo(3)
  assert_equal 40, computer.combo(4)
  assert_equal 50, computer.combo(5)
  assert_equal 60, computer.combo(6)
end

# computer = Computer.new({}, [])

test "Computer#adv" do
  computer = Computer.new({a: 12}, [])
  computer.adv(2)
  assert_equal 3, computer.registers[:a]

  # Combo
  computer = Computer.new({a: 12, b: 2}, [])
  computer.adv(5)
  assert_equal 3, computer.registers[:a]
end

test "Computer#bxl" do
  computer = Computer.new({b: 5}, [])
  computer.bxl(3)
  assert_equal 6, computer.registers[:b]
end

test "Computer#bst" do
  computer = Computer.new({b: nil, c: 10}, [])
  computer.bst(1)
  assert_equal 1, computer.registers[:b]

  # Combo
  computer.bst(6)
  assert_equal 2, computer.registers[:b]
end

test "Computer#jnz" do
  computer = Computer.new({a: 0}, [])
  computer.jnz(9)
  assert_equal 0, computer.instruction_pointer

  computer = Computer.new({a: 1}, [])
  computer.jnz(9)
  assert_equal 9, computer.instruction_pointer
end

test "Computer#bxc" do
  computer = Computer.new({b: 5, c: 3}, [])
  computer.bxc(nil)
  assert_equal 6, computer.registers[:b]
end

test "Computer#out" do
  computer = Computer.new({a: 12}, [])
  computer.out(2)
  assert_equal "2", computer.output

  # Combo
  computer = Computer.new({c: 12}, [])
  computer.out(6)
  assert_equal "4", computer.output
end

test "Computer#bdv" do
  computer = Computer.new({a: 12, b: nil, c: nil}, [])
  computer.bdv(2)
  assert_equal 3, computer.registers[:b]

  # Combo
  computer = Computer.new({a: 12, b: nil, c: 2}, [])
  computer.bdv(6)
  assert_equal 3, computer.registers[:b]
end

test "Computer#cdv" do
  computer = Computer.new({a: 12, b: nil, c: nil}, [])
  computer.cdv(2)
  assert_equal 3, computer.registers[:c]

  # Combo
  computer = Computer.new({a: 12, b: 2, c: 2}, [])
  computer.cdv(5)
  assert_equal 3, computer.registers[:c]
end
