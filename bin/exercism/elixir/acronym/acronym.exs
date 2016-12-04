#!/usr/bin/env elixir
defmodule Acronym do
  @doc """
  Generate an acronym from a string.
  "This is a string" => "TIAS"
  """

  # www.pcre.org/original/doc/html/pcresyntax.html#SEC5
  @spaces ~r{\s+}u
  @non_words ~r/[^0-9\p{L}]+/ui
  @case_change ~r/(\p{Ll})(\p{Lu})/u # todo unicode upcase/lowercase
  @insert_space      "\\1 \\2"

  @spec abbreviate(String.t()) :: String.t()
  def abbreviate(string) do
    string
      |> String.replace(@non_words, " ")
      |> String.replace(@case_change, @insert_space)
      |> String.split(@spaces, trim: true)
      |> Enum.map(&(first_upper(&1)))
      |> List.to_string
  end

  defp first_upper(word) do
    word
      |> String.first
      |> String.upcase
  end

end
