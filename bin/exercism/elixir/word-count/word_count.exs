defmodule Words do
  @doc """
  Count the number of words in the sentence.

  Words are compared case-insensitively.
  """

  @spaces ~r{\s+}u
  @nonwords ~r/[^0-9\p{L}\-]+/ui

  @spec count(String.t) :: map
  def count(sentence) do
    cleansed = String.replace(String.downcase(sentence), @nonwords, " ")
	list = String.split(cleansed, @spaces)
    [first | tail] = list
	count(tail, first)
  end

  defp count(tail, word, map \\ %{})

  defp count([], "", map), do: map

  defp count([], word, map) do
    { _, histogram } = update(map, word)
	histogram
  end

  defp count(tail, "", map) do
	[ word | tail ] = tail
	count(tail, word, map)
  end

  defp count(tail, word, map) do
    { _, newmap } = update(map, word)
	count(tail, "", newmap)
  end

  defp update(map, word) do
    Map.get_and_update(map, word,
	  fn nil -> { 0, 1 }
	    count -> { count, 1 + count}
	  end)
  end
end
