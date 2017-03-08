
defmodule Sequence.Stash do
  use GenServer

  #####
  # External API

  def start_link(current_number) do
    {:ok,_stash_pid} = GenServer.start_link( __MODULE__, current_number)
  end

  ### immutable queries

  def get_value(stash_pid) do
    GenServer.call stash_pid, :get_value
  end

  ### mutable operations

  def save_value(value, stash_pid) do
    GenServer.cast stash_pid, {:save_value, value}
  end

  #####
  # GenServer implementation

  def handle_call(:get_value, _client_pid, current_value) do
    { :reply, current_value, current_value }
  end

  def handle_cast({:save_value, value}, _current_value) do
    { :noreply, value}
  end
end
