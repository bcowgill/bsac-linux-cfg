
defmodule Sequence.Server do
  use GenServer

  @global_name :bsac_sequence

  def start_link(stash_pid, options \\ [{ :name, @global_name }]) do
    { :ok, _server_pid } = GenServer.start_link(
      __MODULE__,
      stash_pid,
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

  def init(stash_pid) do
    current_number = Sequence.Stash.get_value(stash_pid)
	{ :ok, { current_number, stash_pid } }
  end

  def handle_call(:current_number, _client_pid, { current_number, stash_pid }) do
    { :reply, current_number, { current_number, stash_pid } }
  end

  def handle_call(:next_number, _client_pid, { current_number, stash_pid }) do
    { :reply, current_number, { current_number + 1, stash_pid } }
  end

  def handle_cast({:increment_number, delta}, { current_number, stash_pid }) do
    { :noreply, { current_number + delta, stash_pid } }
  end

  def terminate(_reason, { current_number, stash_pid }) do
    Sequence.Stash.save_value(current_number, stash_pid)
  end

end
