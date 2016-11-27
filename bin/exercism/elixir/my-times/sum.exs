defmodule Sums
do
  def sum (1)
  do
    1
  end

  def sum (number)
  do
    sum(number - 1) + number
  end
end
