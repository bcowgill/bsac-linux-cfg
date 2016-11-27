defmodule Gcd
do
  def of(num, 0) when num > 0
  do
    num
  end

  def of(num1, num2) when num1 > 0 and num2 > 0
  do
    of(num2, rem(num1, num2))
  end
end
