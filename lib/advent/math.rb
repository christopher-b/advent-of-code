module Advent
  # Mathematical utilities for solving Advent of Code problems.
  # Provides number theory and statistical functions.
  module Math
    # Solves a system of two linear congruences using the Chinese Remainder Theorem.
    # Finds a number that satisfies: result ≡ x (mod mod1) and result ≡ y (mod mod2)
    #
    # @param x [Integer] The remainder for the first congruence
    # @param mod1 [Integer] The modulus for the first congruence
    # @param y [Integer] The remainder for the second congruence
    # @param mod2 [Integer] The modulus for the second congruence
    # @return [Integer] The solution modulo (mod1 * mod2)
    # @example
    #   chinese_remainder(2, 3, 3, 5)  # => 8
    #   # Because 8 % 3 == 2 and 8 % 5 == 3
    # @see https://en.wikipedia.org/wiki/Chinese_remainder_theorem
    def chinese_remainder(x, mod1, y, mod2)
      n1 = mod2  # Product of the other modulus
      n2 = mod1  # Product of the other modulus

      m1 = mod_inverse(n1, mod1)  # Modular inverse of n1 mod mod1
      m2 = mod_inverse(n2, mod2)  # Modular inverse of n2 mod mod2

      (x * n1 * m1 + y * n2 * m2) % (mod1 * mod2)
    end

    # Computes the greatest common divisor and Bézout coefficients.
    # Returns [gcd, x, y] where gcd = a*x + b*y
    #
    # @param a [Integer] First integer
    # @param b [Integer] Second integer
    # @return [Array(Integer, Integer, Integer)] Tuple of [gcd, x, y]
    # @example
    #   extended_gcd(240, 46)  # => [2, -9, 47]
    #   # Because gcd(240, 46) = 2 = 240*(-9) + 46*47
    # @see https://en.wikipedia.org/wiki/Extended_Euclidean_algorithm
    def extended_gcd(a, b)
      if b == 0
        [a, 1, 0]
      else
        gcd, x, y = extended_gcd(b, a % b)
        [gcd, y, x - (a / b) * y]
      end
    end

    # Computes the modular multiplicative inverse of a modulo m.
    # Finds x such that (a * x) % m == 1
    #
    # @param a [Integer] The number to find the inverse of
    # @param m [Integer] The modulus
    # @return [Integer] The modular inverse in range [0, m-1]
    # @raise [RuntimeError] If no modular inverse exists (when gcd(a, m) != 1)
    # @example
    #   mod_inverse(3, 11)  # => 4
    #   # Because (3 * 4) % 11 == 1
    # @see https://en.wikipedia.org/wiki/Modular_multiplicative_inverse
    def mod_inverse(a, m)
      gcd, x, = extended_gcd(a, m)
      raise "No modular inverse exists!" if gcd != 1

      x % m
    end

    # Calculates the sample variance of a set of numbers.
    # Uses Bessel's correction (dividing by n-1) for unbiased estimation.
    #
    # @param numbers [Array<Numeric>] Array of numbers
    # @return [Float] The variance
    # @example
    #   variance([2, 4, 4, 4, 5, 5, 7, 9])  # => 4.571428571428571
    # @see https://en.wikipedia.org/wiki/Variance
    def variance(numbers)
      mean = numbers.sum.to_f / numbers.size
      numbers.sum { |num| (num - mean)**2 } / (numbers.size - 1)
    end
  end
end
