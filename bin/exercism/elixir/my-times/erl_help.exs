# Provide quick access to help pages on erlang functions

# Erl.h :io        shows all :io methods with direct url to erlang help
# s :io.columns    shows @spec for specific function call
defmodule Erl do
  @url "http://erlang.org/doc/man/"
  def h(module) do
    help = "#{@url}#{module}.html"
    IO.puts help
    module.module_info(:exports)
    |> Enum.map( fn {func, arity} -> ":#{module}.#{func}/#{arity}\t\t#{help}##{func}-#{arity}" end )
    |> Enum.sort( &(&1 < &2) )
    |> Enum.each( fn func -> IO.puts "#{func}" end )
  end
end
