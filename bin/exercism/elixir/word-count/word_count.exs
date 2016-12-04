defmodule Words do
  @doc """
  Count the number of words in the sentence.

  Words are compared case-insensitively.
  """

  # www.pcre.org/original/doc/html/pcresyntax.html#SEC5
  @spaces ~r{\s+}u
  @non_words ~r/[^0-9\p{L}\-]+/ui

  @spec count(String.t) :: map
  def count(sentence) do
    cleansed = String.replace(String.downcase(sentence), @non_words, " ")
	list = String.split(cleansed, @spaces, trim: true)
    [first | tail] = list
	count(tail, first)
  end

  defp count(tail, word, map \\ %{})

  defp count([], word, map) do
    { _, histogram } = update(map, word)
	histogram
  end

  defp count(tail, word, map) do
    { _, newmap } = update(map, word)
  	[ word | tail ] = tail
   	count(tail, word, newmap)
  end

  defp update(map, word) do
    Map.get_and_update(map, word,
	  fn nil -> { 0, 1 }
	    count -> { count, 1 + count}
	  end)
  end
end
