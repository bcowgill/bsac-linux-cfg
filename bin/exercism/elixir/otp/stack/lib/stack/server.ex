
defmodule Stack.Server do
  use GenServer

  def start_link(stack \\ []) do
    { :ok, server_pid } = GenServer.start_link(__MODULE__, stack)
    server_pid
  end

  def pop(server_pid) do
    GenServer.call(server_pid, :pop)
  end

  ### GenServer interface

  def handle_call(:pop, _client_pid, [ pop | stack ]) do
    { :reply, pop, stack }
  end
end
