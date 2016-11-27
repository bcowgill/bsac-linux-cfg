# Example ordering of a module according to the elixir style guide.
# https://github.com/christopheradams/elixir_style_guide

defmodule MyModule do
  @moduledoc """
  An example module
  """

  @behaviour MyBehaviour

  use GenServer
  import Something
  import SomethingElse
  alias My.Long.Module.Name
  alias My.Other.Module.Name
  require Integer

  defstruct name: nil, params: []

  @typedoc The parameters
  @type params :: [{binary, binary}]

  @module_attribute :foo
  @other_attribute 100

  @spec some_function(term) :: result
  def some_function(some_data) do
    {:ok, some_data}
  end

  ...

end
