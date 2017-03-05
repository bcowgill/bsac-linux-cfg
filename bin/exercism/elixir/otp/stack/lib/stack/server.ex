
defmodule Stack.Server do
  use GenServer

  @global_name :bsac_stack

  def start_link(stack \\ [], options \\ [{ :name, @global_name }]) do
    { :ok, server_pid } = GenServer.start_link(
      __MODULE__,
      stack,
      options)
    server_pid
  end

  def pop(server_pid) do
    GenServer.call(server_pid, :pop)
  end

  def length(server_pid) do
    GenServer.call(server_pid, :length)
  end

  ### GenServer interface

  def handle_call(:pop, _client_pid, [ pop | stack ]) do
    { :reply, pop, stack }
  end

  def handle_call(:length, _client_pid, stack) do
    { :reply, Kernel.length(stack), stack }
  end
end
