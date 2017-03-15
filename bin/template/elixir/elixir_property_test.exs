#!/usr/bin/env elixir

# requires mix.exs dependencies:
# 2 needed for ExCheck property based function testing...
# { :triq, github: "triqng/triq", only: :test},
# { :excheck,  "~> 0.4.0", only: :test },

Code.load_file("elixir_module.ex", __DIR__)

ExUnit.start
ExUnit.configure exclude: :pending, trace: true
ExCheck.start

defmodule StatsPropertyTest do
  use ExUnit.Case
  use ExCheck

  @epsilon 1e-6

  describe "list of integer" do

    property "single element lists are their own sum" do
      for_all number in real do
        implies number > 0 do
          Stats.sum([number]) == number
        end
      end
    end

    # implies will show a red X for tests which violate implies
    property "sum equals average times count (implies)" do
      for_all int_list in list(int) do
        close_to(
          Stats.sum(int_list),
          Stats.count(int_list) * Stats.average(int_list),
          @epsilon)
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
