#!/usr/local/bin/elixir -r
# ./tickerd_ring.exs --name tickerd@docuzilla.workshare.com
Code.load_file("ticker_ring.ex", __DIR__)

domain = "akston.home" # "docuzilla.workshare.com"

IO.inspect Node.self
IO.puts inspect TickerRing.start
IO.puts inspect TickerRingClient.start

defmodule NodeConnector do
  def connect(host) do
    Retry.until(tryHost(host), 500, 100)
  end

  defp tryHost(host) do
    fn (_, _) ->
      IO.puts "trying #{host}"
      result = Node.connect :"#{host}"
      IO.puts inspect result
      case result do
        true -> true
        _ -> nil
      end
    end
  end
end

1 .. 4
  |> Enum.each fn num -> NodeConnector.connect("tickerc#{num}@#{domain}") end

:timer.sleep 5 * 60 * 1000
