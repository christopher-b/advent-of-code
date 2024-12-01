require "stringio"

test "is created with input" do
  input = StringIO.new("input")
  challenge = Advent::Challenge.new(input)

  assert StringIO === challenge.input_file

  input.close
end

test "reads lines from input" do
  input = StringIO.new("input")
  challenge = Advent::Challenge.new(input)

  input = challenge.each_line do |line|
    assert line == "input"
  end

  input.close
end

test "reads lines to an array" do
  input = StringIO.new("line1\nline2")
  challenge = Advent::Challenge.new(input)

  lines = challenge.lines
  assert lines.size == 2
  assert lines.first == "line1"
  assert lines.last == "line2"

  input.close
end
