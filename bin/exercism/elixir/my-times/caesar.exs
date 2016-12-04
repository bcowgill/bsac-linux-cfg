defmodule Caesar
do
  @alphabet 26

  def caesar([], _shift_by), do: []

  def caesar(charlist, shift_by) when
    shift_by < 0 do
    positive_shift = @alphabet + abs(div(shift_by, @alphabet)) + shift_by
    caesar(charlist, positive_shift)
  end

  def caesar(charlist, shift_by) do
    [ rot(hd(charlist), shift_by) ] ++ caesar(tl(charlist), shift_by)
  end

  defp rot(codepoint, shift_by) when
    (?a <= codepoint) and (codepoint <= ?z) do
    shift(codepoint, ?a, shift_by)
  end

  defp rot(codepoint, shift_by) when
    (?A <= codepoint) and (codepoint <= ?Z) do
    shift(codepoint, ?A, shift_by)
  end

  defp rot(codepoint, _shift_by), do: codepoint

  defp shift(codepoint, a_codepoint, shift_by) do
    a_codepoint + rem(codepoint - a_codepoint + shift_by, @alphabet)
  end
end
