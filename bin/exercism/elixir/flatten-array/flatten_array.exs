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

  defp do_flatten(into, nil), do: into
  defp do_flatten(into, []), do: into
  defp do_flatten(into, [head | tail]) do
    into
    |> do_flatten(head)
    |> do_flatten(tail)
  end
  defp do_flatten(into, item), do: into ++ List.wrap(item)





  @doc """
  construct some deep arrays of various configurations for testing
  """
  def make_deep1([]), do: nil
  def make_deep1([head | tail]) do
    [make_deep1(tail) | head]
  end

  def make_deep2([]), do: nil
  def make_deep2([head | tail]) do
    [make_deep2(tail), head]
  end

  def make_deep3([]), do: nil
  def make_deep3([head | tail]) do
    [[head | make_deep3(tail)] | head]
  end

  def make_deep4([]), do: nil
  def make_deep4([head | tail]) do
    [head , [make_deep4(tail)]]
  end

end
