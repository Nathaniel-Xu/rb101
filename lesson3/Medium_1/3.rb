def factors(number)
  divisor = number
  factors = []
  until divisor == 0
    factors << number / divisor if number % divisor == 0
    divisor -= 1
  end
  factors
end