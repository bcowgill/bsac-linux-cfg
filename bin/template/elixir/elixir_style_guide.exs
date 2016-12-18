# Example ordering of a module according to the elixir style guide.
# https://github.com/christopheradams/elixir_style_guide

defmodule MyModule do
  @moduledoc """
  An example module with an explanation of its purpose.

  (Examples below will be verified by ExUnit from `docTest MyModule` instruction)

  ## Examples

  ```
  iex> elem({ :ok, "body" }, 1)
  "body"
  ```
  """

  @behaviour MyBehaviour

  use GenServer
  import Something, only: [ method: 2 ]
  import SomethingElse
  alias My.Long.Module.Name
  alias My.Other.Module.Name
  require Integer

  defstruct name: nil, params: []

  @typedoc The parameters for the module.
  @type params :: [{ Atom.t, String.t, binary }]

  @module_attribute :foo
  @other_attribute 100

  @doc """
  An example function with explanation of operation.

  `term` Explanation of term parameter.

  Returns a tuple with :ok or :error and the output data or error message.
  """
  @spec some_function(term) :: result
  def some_function(some_data) do
    {:ok, some_data}
  end

  ...

end
