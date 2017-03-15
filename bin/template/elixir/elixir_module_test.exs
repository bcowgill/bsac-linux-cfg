#!/usr/bin/env elixir
# http://elixir-lang.org/docs/stable/ex_unit/ExUnit.html

Code.load_file("elixir_module.ex", __DIR__)

ExUnit.start
ExUnit.configure exclude: :pending, trace: true

defmodule ElixirModuleTest do
  use ExUnit.Case
  doctest ElixirModule

  describe "unit tests for execute/1" do

    setup do
      [
        name: "Alice"
      ]
    end

    #setup fnSetup also allowed
    # inside fnSetup define callback with on_exit to run after the tests complete

    # @tag: pending
    test "should answer using default parameters" do
      assert ElixirModule.execute() == "Hello, World!"
    end

    @tag :pending
    test "should answer given a specific parameter", fixture do
      assert ElixirModule.execute(fixture.name) == "Hello, Alice!"
    end

  end
end

