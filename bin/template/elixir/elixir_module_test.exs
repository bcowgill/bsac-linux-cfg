#!/usr/bin/env elixir
Code.load_file("elixir_module.exs", __DIR__)

ExUnit.start
ExUnit.configure exclude: :pending, trace: true

defmodule ElixirModuleTest do
  use ExUnit.Case
  docTest ElixirModule

  # @tag: pending
  test "should answer using default parameters" do
    assert ElixirModule.execute() == "Hello, World!"
  end

  @tag :pending
  test "should answer given a specific parameter" do
    assert ElixirModule.execute("Alice") == "Hello, Alice!"
  end

end

