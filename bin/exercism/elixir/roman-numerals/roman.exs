defmodule Roman do
  @doc """
  Convert a number to a roman numeral representation.
  """
  #         1 5 10 50 100 500 1000
  @roman ~w(I V  X  L  C   D    M)

  import String, only: [duplicate: 2]

  @spec numerals(pos_integer) :: String.t
  def numerals(0), do: raise("Romans didn't know about zero!")
  def numerals(number) when number >= 4000 do
     raise("Romans couldn't count that high!")
  end
  def numerals(number) when number < 0 do
     raise("Romans didn't have negative numbers!")
  end

  def numerals(number) do
    roman(number)
  end

  defp roman(number, sigils \\ @roman)

  defp roman(0, _), do: ""

  defp roman(number, sigils) when number >= 10 do
     ones = rem(number, 10)
     tens = div(number, 10)
     roman(tens, tl(tl(sigils))) <> roman(ones, sigils)
  end

  defp roman(number, [ i | _sigils ]) when 3 >= number do
    duplicate(i, number)
  end

  defp roman(number, [ i, v | _sigils ]) when 4 === number do
    i <> v
  end

  defp roman(number, [ i, v | _sigils ]) when 8 >= number do
    v <> duplicate(i, number - 5)
  end

  defp roman(number, [ i, _v, x | _sigils ]) when 9 == number do
    i <> x
  end

  def sigils(), do: @roman

end

# unit testing raise'd errors:
# @tag :done
# test "-1" do
#   assert glove(fn () -> Roman.numerals(-1) end) == "ERROR %RuntimeError{message: \"Romans didn't have negative numbers!\"}"
# end

# # catch any error from raise()
# def glove(func) do
#   try do
#     func.()
#   rescue
#     error -> "ERROR #{inspect error}"
#   end
# end
