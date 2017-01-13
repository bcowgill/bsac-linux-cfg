# Get some help on an erlang module

# Erl.h :io
# s :io.columns
defmodule Erl do
  def h(module) do
    module.module_info(:exports)
    |> Enum.map( fn {func, arity} -> ":#{module}.#{func}/#{arity}" end )
    |> Enum.sort( &(&1 < &2) )
  end
end
