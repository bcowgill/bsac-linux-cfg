
defmodule Sequence.Server do
  use GenServer

  @global_name :bsac_sequence

  def start_link(current_number \\ 0, options \\ [{ :name, @global_name }]) do
    IO.puts "#{__MODULE__}.start_link #{inspect current_number}"
    { :ok, _server_pid } = GenServer.start_link(
      __MODULE__,
      current_number,
      options)
  end

  ### immutable queries

  def current_number(server_pid \\ @global_name) do
    GenServer.call(server_pid, :current_number)
  end

  ### mutable operations

  def next_number(server_pid \\ @global_name) do
    GenServer.call(server_pid, :next_number)
  end

  def increment_number(delta, server_pid \\ @global_name) do
    GenServer.cast(server_pid, { :increment_number, delta })
  end

  ### GenServer interface

  def handle_call(:current_number, _client_pid, current_number) do
    { :reply, current_number, current_number }
  end

  def handle_call(:next_number, _client_pid, current_number) do
    { :reply, current_number, current_number + 1 }
  end

  def handle_cast({:increment_number, delta}, current_number) do
    { :noreply, current_number + delta}
  end

  def format_status(_reason, [ _pdict, state ]) do
    [data: [{'State', "My current state is '#{inspect state}', and I'm happy"}]]
  end

  def terminate(reason, state) do
    IO.puts "#{__MODULE__} terminating #{inspect reason} #{inspect state}"
  end

end
