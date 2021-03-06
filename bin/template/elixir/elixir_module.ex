defmodule ElixirModule do
  @moduledoc """
  A template elixir module with accompanying unit test file.

  ## Examples

  ```
  iex> ElixirModule.execute("John")
  "Hello, John!"
  ```
  """

  @doc """
  The module's main function.
  """
  @spec execute(String.t) :: String.t
  def execute(name \\ "World"), do: "Hello, #{name}!"

end
