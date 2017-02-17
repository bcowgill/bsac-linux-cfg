#!/usr/local/bin/elixir -r
# ./tickerc.exs --name tickerc@docuzilla.workshare.com
Code.load_file("ticker_client.ex", __DIR__)
IO.inspect Node.self
TickerClient.start
:timer.sleep 40000
