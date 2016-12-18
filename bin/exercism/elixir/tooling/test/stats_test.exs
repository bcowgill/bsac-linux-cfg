defmodule TestStats do
  use ExUnit.Case
#  doctest Stats

  describe "list of integer" do

    setup do
      [ list:    [1, 3, 5, 7, 9, 11],
        sum:     36,
        count:   6
      ]
    end

    test "calculates sum", fixture do
      assert Stats.sum(fixture.list) == fixture.sum
    end

    test "calculates count", fixture do
      assert Stats.count(fixture.list) == fixture.count
    end

    test "calculates average", fixture do
      assert Stats.average(fixture.list) == fixture.sum / fixture.count
    end

  end
end
