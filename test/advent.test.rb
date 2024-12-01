test "pads a day" do
  assert Advent.pad_day(1) == "01"
  assert Advent.pad_day(10) == "10"
end
