#!/usr/bin/env elixir
if !System.get_env("EXERCISM_TEST_EXAMPLES") do
  Code.load_file("flatten_array.exs", __DIR__)
end

ExUnit.start
ExUnit.configure exclude: :pending, trace: true

defmodule FlattenArrayTest do
  use ExUnit.Case

  @big 10_000

  test "returns original list if there is nothing to flatten" do
    assert FlattenArray.flatten([1, 2, 3]) ==  [1, 2, 3]
  end

  @tag :done
  test "flattens an empty nested list" do
    assert FlattenArray.flatten([[]]) ==  []
  end

  @tag :done
  test "flattens a nested list" do
    assert FlattenArray.flatten([1,[2,[3],4],5,[6,[7,8]]]) == [1, 2, 3, 4, 5, 6, 7, 8]
  end

  @tag :done
  test "removes nil from list" do
    assert FlattenArray.flatten([1, nil, 2]) ==  [1, 2]
  end

  @tag :done
  test "removes nil from a nested list" do
    assert FlattenArray.flatten([1, [2, nil, 4], 5]) ==  [1, 2, 4, 5]
  end

  @tag :done
  test "returns an empty list if all values in nested list are nil" do
    assert FlattenArray.flatten([nil, [nil], [nil, [nil]]]) ==  []
  end

  @tag :done
  test "returns flat from a huge deep list of type 1" do
    biggie = Enum.to_list(1..@big)
    deep = FlattenArray.make_deep1(biggie)
    assert FlattenArray.flatten(deep) == Enum.reverse(biggie)
  end

  @tag :done
  test "returns flat from a huge deep list of type 2" do
    biggie = Enum.to_list(1..@big)
    deep = FlattenArray.make_deep2(biggie)
    assert FlattenArray.flatten(deep) == Enum.reverse(biggie)
  end

  @tag :done
  test "returns flat from a huge deep list of type 3" do
    biggie = Enum.to_list(1..@big)
    deep = FlattenArray.make_deep3(biggie)
    assert FlattenArray.flatten(deep) == biggie ++ Enum.reverse(biggie)
  end

  @tag :done
  test "returns flat from a huge deep list of type 4" do
    biggie = Enum.to_list(1..@big)
    deep = FlattenArray.make_deep4(biggie)
    assert FlattenArray.flatten(deep) == biggie
  end
end
