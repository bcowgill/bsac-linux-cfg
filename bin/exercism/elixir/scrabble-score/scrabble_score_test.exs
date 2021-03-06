#!/usr/bin/env elixir
if !System.get_env("EXERCISM_TEST_EXAMPLES") do
  Code.load_file("scrabble.exs", __DIR__)
end

ExUnit.start
ExUnit.configure exclude: :pending, trace: true

defmodule ScrabbleScoreTest do
  use ExUnit.Case

  @tag :done
  test "empty word scores zero" do
    assert Scrabble.score("") == 0
  end

  @tag :done
  test "whitespace scores zero" do
    assert Scrabble.score(" \t\n") == 0
  end

  @tag :done
  test "scores very short word" do
    assert Scrabble.score("a") == 1
  end

  @tag :done
  test "scores other very short word" do
    assert Scrabble.score("f") == 4
  end

  @tag :done
  test "simple word scores the number of letters" do
    assert Scrabble.score("street") == 6
  end

  @tag :done
  test "complicated word scores more" do
    assert Scrabble.score("quirky") == 22
  end

  @tag :done
  test "scores are case insensitive" do
    assert Scrabble.score("OXYPHENBUTAZONE") == 41
  end

  @tag :done
  test "convenient scoring" do
    assert Scrabble.score("alacrity") == 13
  end
end
