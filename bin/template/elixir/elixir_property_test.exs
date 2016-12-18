#!/usr/bin/env elixir

# requires mix.exs dependencies:
# 2 needed for ExCheck property based function testing...
# { :triq, github: "triqng/triq", only: :test},
# { :excheck,  "~> 0.4.0", only: :test },

Code.load_file("elixir_module.exs", __DIR__)

ExUnit.start
ExUnit.configure exclude: :pending, trace: true
ExCheck.start

defmodule StatsPropertyTest do
  use ExUnit.Case
  use ExCheck

  describe "list of integer" do
    property "single element lists are their own sum" do
      for_all number in real do
        Stats.sum([number]) == number
      end
    end
  end
end
