# Advent of Code

My solutions to the [Advent of Code](https://adventofcode.com/) challenges.

This project includes some scaffolding around the challenges, including a script to initialize the challenge, tests and data for each day. It also includes a script to run the solutions for a given day.

- `mise run test` or `bin/qt` to run all tests (includes the tests for the solutions and the scaffolding)
- `mise run test-watch` or `bin/guard` to run tests in watch mode
- `exe/advent init YEAR DAY` to initialize a new day's challenge class, test and data files. Requires the `AOC_SESSION` env var. Get it from a cookie in a browser session.
- `exe/advent go YEAR DAY` to run the solutions for a given day.
