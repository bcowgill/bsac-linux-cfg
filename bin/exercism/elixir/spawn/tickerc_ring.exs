#!/usr/local/bin/elixir -r
# ./tickerc_ring.exs --name tickerc@docuzilla.workshare.com
Code.load_file("ticker_ring_client.ex", __DIR__)
IO.inspect Node.self
:timer.sleep 8000
TickerRingClient.start
:timer.sleep 40000
