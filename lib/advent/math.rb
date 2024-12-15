module Advent
  module Math
    # Chinese Remainder Theorem
    def chinese_remainder(x, mod1, y, mod2)
      n1 = mod2  # Product of the other modulus
      n2 = mod1  # Product of the other modulus

      m1 = mod_inverse(n1, mod1)  # Modular inverse of n1 mod mod1
      m2 = mod_inverse(n2, mod2)  # Modular inverse of n2 mod mod2

      (x * n1 * m1 + y * n2 * m2) % (mod1 * mod2)
    end

    # Extended Euclidean Algorithm
    # https://en.wikipedia.org/wiki/Extended_Euclidean_algorithm
    def extended_gcd(a, b)
      if b == 0
        [a, 1, 0]
      else
        gcd, x, y = extended_gcd(b, a % b)
        [gcd, y, x - (a / b) * y]
      end
    end

    # https://en.wikipedia.org/wiki/Modular_multiplicative_inverse
    def mod_inverse(a, m)
      gcd, x, _ = extended_gcd(a, m)
      raise "No modular inverse exists!" if gcd != 1
      x % m
    end

    # Calculate the sum of squared differences from the mean
    # https://en.wikipedia.org/wiki/Mean_squared_error
    def variance(numbers)
      mean = numbers.sum.to_f / numbers.size
      numbers.sum { |num| (num - mean)**2 } / (numbers.size - 1)
    end
  end
end
