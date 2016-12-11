defmodule Scrabble do
  @number ~r{\d}
  @letter ~r{([a-z])}i
  @scores ~W[
    1 A E I O U L N R S T
    2 D G
    3 B C M P
    4 F H V W Y
    5 K
    8 J X
    10 Q Z
  ]

  @doc """
  Calculate the scrabble score for the word.
  """
  @spec score(String.t) :: non_neg_integer
  def score(word) do
    with values = get_values(%{}, @scores) do
      word
      |> get_letters
      |> compute_score(values)
    end
  end

  @doc """
  Get the letters of the word so we can score them
  """
  @spec get_letters(String.t) :: [String.t]
  def get_letters(word) do
    Regex.scan(@letter, word, capture: :all_but_first, trim: true)
    |> List.flatten
  end

  @doc """
  Compute the score from list of letters
  """
  @spec compute_score(String.t, Map.t) :: non_neg_integer
  def compute_score(letters, values) do
      letters
      |> Enum.reduce(0, fn letter, score -> score + score_this(values, letter) end)
  end

  @doc """
  Score the value of a single letter
  """
  @spec score_this(Map.t, String.t) :: non_neg_integer
  def score_this(values, letter) do
    Map.get(values, letter, 0)
  end

  @doc """
  Get the map of scrabble values by letter.
  """
  @spec get_values(Map.t, [String.t]) :: Map.t
  def get_values(map, [ value | tail ]) do
    put_value(map, String.to_integer(value), tail)
  end

  # convert list of value, letters into a Map of letter => value
  defp put_value(map, value, [letter | tail]) do
    if (Regex.match?(@number, letter)) do
      map
      |> put_value(String.to_integer(letter), tail)
    else
      map
      |> Map.put(letter, value)
      |> Map.put(String.downcase(letter), value)
      |> put_value(value, tail)
    end
  end
  defp put_value(map, _, []), do: map
end
