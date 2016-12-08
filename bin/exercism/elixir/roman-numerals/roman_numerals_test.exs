#!/usr/bin/env elixir
if !System.get_env("EXERCISM_TEST_EXAMPLES") do
  Code.load_file("roman.exs", __DIR__)
end

ExUnit.start
ExUnit.configure exclude: :pending, trace: true

defmodule RomanTest do
  use ExUnit.Case

  @tag :done
  test "1" do
    assert Roman.numerals(1) == "I"
  end

  @tag :done
  test "2" do
    assert Roman.numerals(2) == "II"
  end

  @tag :done
  test "3" do
    assert Roman.numerals(3) == "III"
  end

  @tag :done
  test "4" do
    assert Roman.numerals(4) == "IV"
  end

  @tag :done
  test "5" do
    assert Roman.numerals(5) == "V"
  end

  @tag :done
  test "6" do
    assert Roman.numerals(6) == "VI"
  end

  @tag :done
  test "9" do
    assert Roman.numerals(9) == "IX"
  end

  @tag :done
  test "10" do
    assert Roman.numerals(1) == "I"
  end

  @tag :done
  test "27" do
    assert Roman.numerals(27) == "XXVII"
  end

  @tag :done
  test "48" do
    assert Roman.numerals(48) == "XLVIII"
  end

  @tag :done
  test "59" do
    assert Roman.numerals(59) == "LIX"
  end

  @tag :done
  test "93" do
    assert Roman.numerals(93) == "XCIII"
  end

  @tag :done
  test "141" do
    assert Roman.numerals(141) == "CXLI"
  end

  @tag :done
  test "163" do
    assert Roman.numerals(163) == "CLXIII"
  end

  @tag :done
  test "402" do
    assert Roman.numerals(402) == "CDII"
  end

  @tag :done
  test "575" do
    assert Roman.numerals(575) == "DLXXV"
  end

  @tag :done
  test "911" do
    assert Roman.numerals(911) == "CMXI"
  end

  @tag :done
  test "1024" do
    assert Roman.numerals(1024) == "MXXIV"
  end

  @tag :done
  test "3999" do
    assert Roman.numerals(3999) == "MMMCMXCIX"
  end

  @tag :done
  test "4000" do
    assert glove(fn () -> Roman.numerals(4000) end) == "ERROR %RuntimeError{message: \"Romans couldn't count that high!\"}"
  end

  @tag :done
  test "0" do
    assert glove(fn () -> Roman.numerals(0) end) == "ERROR %RuntimeError{message: \"Romans didn't know about zero!\"}"
  end

  @tag :done
  test "-1" do
    assert glove(fn () -> Roman.numerals(-1) end) == "ERROR %RuntimeError{message: \"Romans didn't have negative numbers!\"}"
  end

  # catch any error from raise()
  def glove(func) do
    try do
      func.()
    rescue
      error -> "ERROR #{inspect error}"
    end
  end

end
