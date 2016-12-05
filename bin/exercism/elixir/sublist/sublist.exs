defmodule Sublist do
  @doc """
  Returns whether the first list is a sublist or a superlist of the second list
  and if not whether it is equal or unequal to the second list.
  """
  def compare([], []), do: :equal
  def compare([], _),  do: :sublist
  def compare(_, []),  do: :superlist

  def compare(a, b) when
    is_list(a) and is_list(b) do
    trace("cmp1", a, b)
    cond do
      (a === b) -> :equal
      scan_forward(a, b) -> :sublist
      scan_forward(b, a) -> :superlist
      :otherwise -> :unequal
    end
  end

  defp scan_forward(a, []), do: trace("sfA", false)

  defp scan_forward(a = [ first | a_tail ], b = [ first | b_tail ] ) do
    trace("sf0", a, b)
    sublist(a_tail, b_tail) or scan_forward(a, b_tail)
  end

  defp scan_forward(a, b =[ _b_first | b_tail ]) do
    trace("sf1", a, b)
    scan_forward(a, b_tail)
  end

  defp sublist([], _), do: trace("sblA", true)
  defp sublist(_, []), do: trace("sblB", false)

  defp sublist(a = [ a_first | a_tail ], b = [ a_first | b_tail ]) do
    trace("sbl0", a, b)
    sublist(a_tail, b_tail)
  end

  defp sublist(a, b), do: trace("sblC", false)

  defp trace(msg, value) do
    #IO.puts("\n" <> msg)
    #IO.inspect(value)
    value
  end

  defp trace(msg, a, b) do
    #IO.puts("\n" <> msg)
    #IO.inspect(%{ a: a, b: b })
  end
end
