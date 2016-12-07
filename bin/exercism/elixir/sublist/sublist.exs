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
    result = scan_forward(a, b, :equal)
    case result do
      false -> not_equal(scan_forward(b, a, :superlist))
      _ -> result
    end
  end

  # scan_mode = :equal, :sublist, :superlist depending on where we started
  defp scan_forward(a, b, scan_mode)
  defp scan_forward(_a, [], _), do: trace("sfA", false)

  defp scan_forward(a = [ first | a_tail ], b = [ first | b_tail ], scan_mode ) do
    trace("sf0", a, b)
    result = sublist(a_tail, b_tail)
    case result do
      :equal -> scan_mode
      true -> is_sublist(scan_mode)
      false -> scan_forward(a, b_tail, not_equal(scan_mode))
      _ -> result
    end
  end

  defp scan_forward(a, b =[ _b_first | b_tail ], scan_mode) do
    trace("sf1", a, b)
    scan_forward(a, b_tail, not_equal(scan_mode))
  end

  # result is a sublist, convert as needed
  defp is_sublist(:equal), do: :sublist
  defp is_sublist(scan_mode), do: scan_mode

  # result cannot be :equal so convert as needed
  defp not_equal(false), do: :unequal
  defp not_equal(:equal), do: :sublist
  defp not_equal(scan_mode), do: scan_mode

  defp sublist([], []), do: trace("sblA", :equal)
  defp sublist([], _), do: trace("sblB", true)
  defp sublist(_, []), do: trace("sblC", false)

  defp sublist(a = [ a_first | a_tail ], b = [ a_first | b_tail ]) do
    trace("sbl0", a, b)
    sublist(a_tail, b_tail)
  end

  defp sublist(_a, _b), do: trace("sblC", false)

  defp trace(_msg, value) do
#    IO.puts("\n" <> msg)
#    IO.inspect(value)
    value
  end

  defp trace(_msg, _a, _b) do
#    IO.puts("\n" <> msg)
#    IO.inspect(%{ a: a, b: b })
  end

#  defp trace(msg, a, b, c) do
#    IO.puts("\n" <> msg)
#    IO.inspect(%{ a: a, b: b, c: c })
#  end
end
