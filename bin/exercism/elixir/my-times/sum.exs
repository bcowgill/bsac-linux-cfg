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

  def span(from, from), do: [from]

  def span(from, to) when
    from <= to do
    [ from | span(from + 1, to)]
  end
end
