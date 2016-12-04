defmodule Sum
do
  def mapsum([], _func), do: 0
  def mapsum(list, func) do
    func.(hd(list)) + mapsum(tl(list), func)
  end

  def max([]), do: nil
  def max([only | []]), do: only
  def max([head | tail]) do
    tailmax = max(tail)
    cond do
      head > tailmax -> head
      :otherwise -> tailmax
    end
  end

  def caesar([], _n), do: []
  def caesar(list, n) do
    [ rot(hd(list), n) ] ++ caesar(tl(list), n)
  end

  def rot(char, n) when
    ('a' <= char) and (char <= 'z') do
    shift(char, 'a', n)
  end

  def rot(char, n) when
    ('A' <= char) and (char <= 'Z') do
    shift(char, 'a', n)
  end

  def rot(char, _n), do: char

  defp shift(char, a, n) do
    char + rem(a + n, 26)
  end
end
