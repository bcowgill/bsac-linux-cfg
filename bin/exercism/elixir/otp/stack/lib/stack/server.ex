
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

  ### immutable queries

  def length(server_pid) do
    GenServer.call(server_pid, :length)
  end

  def pop(server_pid) do
    GenServer.call(server_pid, :pop)
  end

  ### mutable operations

  def push(server_pid, value) do
    GenServer.cast(server_pid, { :push, value })
  end

  def push_list(server_pid, list)
  when is_list(list) do
    GenServer.cast(server_pid, { :push_list, list })
  end

  ### GenServer interface

  def handle_call(:pop, _client_pid, [ pop | stack ]) do
    { :reply, pop, stack }
  end

  def handle_call(:length, _client_pid, stack) do
    { :reply, Kernel.length(stack), stack }
  end

  def handle_cast({ :push, value }, stack) do
    { :noreply, [ value | stack ] }
  end

  def handle_cast({ :push_list, list }, stack) do
    { :noreply, List.flatten(
      List.insert_at(
        list,
        Kernel.length(list), stack)) }
  end
end
