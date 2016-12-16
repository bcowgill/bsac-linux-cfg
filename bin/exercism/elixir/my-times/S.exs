defmodule S do
  @moduledoc """
  The missing string functions
  """

  @spaces ~r{\s+}u

  @doc """
  Collapse all spacing down to a single space.
  """
  @spec single_space(String.t) :: String.t
  def single_space(string) when is_binary(string) do
     string
     |> String.replace(@spaces, " ")
     |> String.trim
  end

  @doc """
  Center a string within a given width.
  """
  @spec center(String.t, non_neg_integer) :: String.t
  def center(string, width, char \\ 32)
  def center(string, width, char) when
    is_integer(char) and width >= 0
  do
    length = String.length(string)
    needed = width - length
    if (needed >= 0) do
      string
      |> String.pad_leading(length + div(needed, 2), <<char>>)
      |> String.pad_trailing(length + needed, <<char>>)
    else
      string
    end
  end

  @doc """
  Center justify a string within a given width.
  """
  @spec cjust(String.t, non_neg_integer) :: String.t
  def cjust(string, width, char \\ 32)
  def cjust(string, width, char) when
    is_integer(char) and width >= 0
  do
    string = single_space(string)
    length = String.length(string)
    needed = width - length
    if (needed >= 0) do
      words = String.split(string)
      pad = div(needed, Enum.count(words))
      for word <- words do
        needed = needed - pad
        word <> String.pad_leading("", pad, char)
      end
    else
      string
    end
  end

end
