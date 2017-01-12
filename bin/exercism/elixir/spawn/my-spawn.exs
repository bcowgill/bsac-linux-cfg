#!/usr/local/bin/elixir -r
defmodule MySpawn do
  def greet do
    receive do
      {sender, token} ->
        send sender, { self, token }
    end
  end

  def get do
    receive do
      {_, message} -> IO.puts message
	  after 500 -> IO.puts "no response"
    end
  end

  def await(pid) do
    receive do
	  {^pid, message} -> IO.puts message
	  after 500 -> IO.puts "#{inspect pid} error, no response received"
	end
  end

  def sendit(pid, token) do
    send(pid, {self, token})
	pid
  end

end

# here's a client
pids = [
  {:fred,  spawn(MySpawn, :greet, [])},
  {:betty, spawn(MySpawn, :greet, [])}
]

IO.puts inspect pids

# results are deterministic now.

result = pids
  |> Enum.map(fn ({token, pid}) -> MySpawn.sendit(pid, token) end)
#  |> Enum.map(fn ({token, pid}) -> send(pid, {self, token }); pid end)

#  |> Enum.reverse
  |> Enum.map(fn (pid) -> MySpawn.await(pid) end)

IO.puts inspect result



