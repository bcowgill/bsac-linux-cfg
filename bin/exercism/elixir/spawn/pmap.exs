#!/usr/local/bin/elixir -r

defmodule Parallel do
  #import :timer, only: [ sleep: 1 ]

  def pmap(collection, fun) do
    me = self
    collection
    |> Enum.map(fn (elem) ->
         spawn_link fn -> (sleepy_send me, { self, fun.(elem) }) end
       end)
    |> Enum.map(fn (pid) ->
         receive do { ^pid, result } -> result end
       end)
  end

  defp sleepy_send(pid, message) do
    #sleep random(100..500)
    send pid, message
  end

  defp random(min..max)
  do
    range = max - min + 1
    :rand.uniform(range) + min - 1
  end

end

IO.puts inspect Parallel.pmap 1..10, &(&1 * &1)
