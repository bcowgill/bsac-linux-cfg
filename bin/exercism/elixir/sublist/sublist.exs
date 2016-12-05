defmodule Sublist do
  @doc """
  Returns whether the first list is a sublist or a superlist of the second list
  and if not whether it is equal or unequal to the second list.
  """
  def compare([ a | [] ], [ b | [] ]) do
    cond do
      (a === b) -> :equal
      :otherwise -> :unequal
    end
  end

  def compare(a, b) when
    is_list(a) and is_list(b) do
    cond do
      (a === b) -> :equal
      sublist(a, b) -> :sublist
      superlist(a, b) -> :superlist
      :otherwise -> :unequal
    end
  end

  def sublist([], _), do: true
  def sublist(_, []), do: false

  def sublist([ a | a_tail ], [ a | b_tail ]) do
    sublist(a_tail, b_tail) or scan(a, b_tail)
  end

  def sublist(a, [ _b | b_tail ]) do
    sublist(a, b_tail)
  end

  def scan(_a, []), do: false

  def scan(a = [ a_first | _ ], b = [ a_first | b_tail ]) do
    sublist(a, b) or scan(a, b_tail)
  end

  def scan(a, [ _b | b_tail ]) do
    false # scan(a, b_tail)
  end

  def superlist(_, []), do: true

  def superlist([ a_first | a_tail], [a_first | b_tail ]) do
    superlist(a_tail, b_tail)
  end

  def superlist([ _a | [] ], [ _b | _b_tail ]), do: false
  def superlist([ _a | [] ], [ _b | [] ]), do: false

  def superlist([ _a_first | a_tail], b) do
    superlist(a_tail, b)
  end


end
