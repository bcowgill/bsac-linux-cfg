#!/usr/bin/env elixir
defmodule FlattenArray do
  @doc """
    Accept a list and return the list flattened without nil values.

    ## Examples

      iex> FlattenArray.flatten([1, [2], 3, nil])
      [1,2,3]

      iex> FlattenArray.flatten([nil, nil])
      []

  """

  @spec flatten(list) :: list
  def flatten(list) when
    is_list(list)
  do
    do_flatten([], list)
  end

  defp do_flatten(into, []), do: Enum.reverse(into)
  defp do_flatten(into, [ head | tail ]) when
    is_list(head)
  do
    into
    |> do_flatten(head)
    |> Enum.reverse
    |> do_flatten(tail)
  end

  defp do_flatten(into, [ nil | tail ]) do
    do_flatten(into, tail)
  end

  defp do_flatten(into, [ head | tail ]) do
    do_flatten([ head | into ], tail)
  end
end
