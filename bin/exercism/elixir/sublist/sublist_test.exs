#!/usr/bin/env elixir
if !System.get_env("EXERCISM_TEST_EXAMPLES") do
  Code.load_file("sublist.exs", __DIR__)
end

ExUnit.start
ExUnit.configure exclude: :pending, trace: true

defmodule SublistTest do
  use ExUnit.Case

  @tag :done
  test "empty equals empty" do
    assert Sublist.compare([], []) == :equal
  end

  @tag :done
  test "empty is a sublist of anything" do
    assert Sublist.compare([], [nil]) == :sublist
  end

  @tag :done
  test "anything is a superlist of empty" do
    assert Sublist.compare([nil], []) == :superlist
  end

  @tag :done
  test "1 is not 2" do
    assert Sublist.compare([1], [2]) == :unequal
  end

  @tag :done
  test "comparing massive equal lists" do
    l = Enum.to_list(1..1_000_000)
    assert Sublist.compare(l, l) == :equal
  end

  @tag :done
  test "sublist at start" do
    assert Sublist.compare([1,2,3],[1,2,3,4,5]) == :sublist
  end

  @tag :done
  test "sublist in middle" do
    assert Sublist.compare([4,3,2],[5,4,3,2,1]) == :sublist
  end

  @tag :done
  test "sublist at end" do
    assert Sublist.compare([3,4,5],[1,2,3,4,5]) == :sublist
  end

  @tag :done
  test "partially matching sublist at start" do
    assert Sublist.compare([1,1,2], [1,1,1,2]) == :sublist
  end

  @tag :done
  test "sublist early in huge list" do
    assert Sublist.compare([3,4,5], Enum.to_list(1..1_000_000)) == :sublist
  end

  @tag :done
  test "mid size sublist not in mid size list" do
    assert Sublist.compare(Enum.to_list(10..1_00),
                           Enum.to_list(1..2_0))
           == :unequal
  end

  @tag :done
  test "huge sublist not in huge list" do
    assert Sublist.compare(Enum.to_list(10..1_000_001),
                           Enum.to_list(1..1_000_000))
           == :unequal
  end

  @tag :done
  test "superlist at start" do
    assert Sublist.compare([1,2,3,4,5],[1,2,3]) == :superlist
  end

  @tag :done
  test "superlist in middle" do
    assert Sublist.compare([5,4,3,2,1],[4,3,2]) == :superlist
  end

  @tag :done
  test "superlist at end" do
    assert Sublist.compare([1,2,3,4,5],[3,4,5]) == :superlist
  end

  @tag :done
  test "1 and 2 does not contain 3" do
    assert Sublist.compare([1,2], [3]) == :unequal
  end

  @tag :done
  test "partially matching superlist at start" do
    assert Sublist.compare([1,1,1,2], [1,1,2]) == :superlist
  end

  @tag :done
  test "superlist early in huge list" do
    assert Sublist.compare(Enum.to_list(1..1_000_000), [3,4,5]) == :superlist
  end

  @tag :done
  test "sublist late in huge list" do
    assert Sublist.compare(Enum.to_list(1..10_000_000), Enum.to_list(1..10_000_001)) == :sublist
  end

  @tag :done
  test "superlist late in huge list" do
    assert Sublist.compare(Enum.to_list(1..10_000_001), Enum.to_list(1..10_000_000)) == :superlist
  end

  @tag :done
  test "equal in huge list" do
    assert Sublist.compare(Enum.to_list(1..10_000_000), Enum.to_list(1..10_000_000)) == :equal
  end

  @tag :done
  test "not equal in huge list" do
    assert Sublist.compare(Enum.to_list(2..10_000_003), Enum.to_list(1..10_000_002)) == :unequal
  end

  @tag :done
  test "strict equality needed" do
    assert Sublist.compare([1], [1.0, 2]) == :unequal
  end

  @tag :done
  test "recurring values sublist" do
    assert Sublist.compare([1,2,1,2,3], [1,2,3,1,2,1,2,3,2,1]) == :sublist
  end

  @tag :done
  test "recurring values unequal" do
    assert Sublist.compare([1,2,1,2,3], [1,2,3,1,2,3,2,3,2,1]) == :unequal
  end

end

#ExUnit.Server.cases_loaded()
#ExUnit.run()

# invoke debugger
#  require IEx
#  IEx.pry
