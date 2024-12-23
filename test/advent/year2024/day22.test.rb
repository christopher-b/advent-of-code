# https://adventofcode.com/2024/day/22
challenge = Advent::Challenge.get_with_sample(year: 2024, day: 22)

test "part 1" do
  # assert_equal 37327623, challenge.part1
  # assert_equal 1110806, challenge.part1
end

test "part 2" do
  assert_equal 23, challenge.part2
end

# test "evolve" do
#   assert_equal 15887950, challenge.evolve_secret(123)
# end

test "parsed_prices" do
  # pp challenge.parsed_prices
  # max = challenge.parsed_prices.values.max
  # pp challenge.parsed_prices.key(max)
  # pp challenge.parsed_prices["[-2, 1, -1, 3]"]
end

# test "secrets" do
#   assert_equal [1, 10, 100, 2024], challenge.secrets
# end

# test "evolved_secrets" do
#   pp ""
#   pp challenge.evolved_secrets
# end

# test "prices" do
#   pp ""
#   pp challenge.prices
# end
#
# test "secret_deltas" do
#   pp ""
#   pp challenge.secret_deltas
# end
#
