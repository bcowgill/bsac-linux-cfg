defmodule Times do
  def double (number)
  do
    2 * number
  end

  def triple (number)
  do
    3 * number
  end

  def quadruple (number)
  do
    double(double(number))
  end
end
