# requires mix.exs dependencies:
# 2 needed for ExCheck property based function testing...
# { :triq, github: "triqng/triq", only: :test},
# { :excheck,  "~> 0.4.0", only: :test },

defmodule StatsPropertyTest do
  use ExUnit.Case
  use ExCheck

  @epsilon 1.0e-6

  describe "list of integer" do

    property "count not negative" do
      for_all int_list in list(int), do: Stats.count(int_list) >= 0
    end

    property "single element lists are their own sum" do
      for_all number in real do
        Stats.sum([number]) == number
      end
    end

    # implies will show a red X for tests which violate implies
    property "sum equals average times count (implies)" do
      for_all int_list in list(int) do
        implies length(int_list) > 0 do
          close_to(
            Stats.sum(int_list),
            Stats.count(int_list) * Stats.average(int_list),
            @epsilon)
        end
      end
    end

    # such that will never run tests which violate condition
    property "sum equals average times count (such_that)" do
      for_all int_list in such_that(int_list in list(int) when length(int_list) > 0) do
          close_to(
            Stats.sum(int_list),
            Stats.count(int_list) * Stats.average(int_list),
            @epsilon)
      end
    end

  end

  defp close_to(actual, expect, epsilon) do
    abs(actual - expect) < epsilon
  end

end
