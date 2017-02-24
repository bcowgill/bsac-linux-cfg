#!/usr/local/bin/elixir -r
# ./tickerc_ring.exs --name tickerc1@docuzilla.workshare.com
Code.load_file("ticker_ring_client.ex", __DIR__)
IO.inspect Node.self
TickerRingClient.ensure_start
:timer.sleep 5 * 60 * 1000
